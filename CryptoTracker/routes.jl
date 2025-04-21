using Genie.Router
using Genie.Renderer.Html
using HTTP, JSON3

route("/") do
    coins = fetch_top_cryptos(5)
    html = """
    <h1>📊 Top 5 Cryptocurrencies</h1>
    <table border="1" cellspacing="0" cellpadding="5">
    <tr><th>Name</th><th>Symbol</th><th>Price (USD)</th><th>Market Cap (USD)</th></tr>
    """
    for c in coins
        html *= """
        <tr>
            <td>$(c["name"])</td>
            <td>$(uppercase(c["symbol"]))</td>
            <td>\$$(round(c["current_price"], digits=2))</td>
            <td>\$$(round(c["market_cap"]/1e9, digits=2)) B</td>
        </tr>
        """
    end
    html *= "</table>"
    return html
end

function fetch_top_cryptos(n::Int=5)
    url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$n&page=1"
    response = HTTP.get(url)
    return JSON3.read(String(response.body))
end
