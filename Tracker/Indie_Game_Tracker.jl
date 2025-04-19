using HTTP, Gumbo, Cascadia

function get_text(node)
    node === nothing && return ""
    isa(node, Bool) && return ""
    
    if node.nodeType == Gumbo.TEXT_NODE
        return strip(node.text)
    elseif node.nodeType == Gumbo.ELEMENT_NODE
        return join(filter(!isempty, get_text.(node.children)), " ") |> strip
    else
        return ""
    end
end

url = "https://itch.io/games/newest"

try
    response = HTTP.get(url)
    html = parsehtml(String(response.body))
    games = []

    for card in eachmatch(Selector("div.game_cell_data"), html.root)
        # Safe title extraction
        title = "N/A"
        link = "N/A"
        title_node = match(Selector("div.game_title"), card)
        if title_node !== nothing && isa(title_node, Gumbo.HTMLElement)
            title = get_text(title_node)
            if haskey(title_node.attributes, "href")
                link = "https://itch.io$(title_node.attributes["href"])"
            end
        end

        # Safe creator extraction
        creator = "Unknown"
        creator_node = match(Selector("div.game_author"), card)
        if creator_node !== nothing
            creator = get_text(creator_node)
        end

        push!(games, (; title, creator, link))
    end

    # Print first 5 games
    foreach(games[1:min(5, end)]) do game
        println("🎮 ", game.title)
        println("👤 ", game.creator)
        println("🔗 ", game.link)
        println("─"^30)
    end

catch e
    println("Error: ", e)
end