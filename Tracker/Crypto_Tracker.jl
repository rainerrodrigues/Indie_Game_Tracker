using HTTP, JSON3, Plots, PrettyTables

# Function to fetch top N cryptocurrencies
function fetch_top_cryptos(n::Int=5)
    url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$n&page=1"
    response = HTTP.get(url)
    return JSON3.read(String(response.body))
end

# Function to fetch historical prices for a specific coin (last 7 days)
function fetch_historical_prices(coin_id::String)
    url = "https://api.coingecko.com/api/v3/coins/$coin_id/market_chart?vs_currency=usd&days=7"
    response = HTTP.get(url)
    data = JSON3.read(String(response.body))
    return data["prices"]  # array of [timestamp, price]
end

# Display top coins in a table
function show_table(coins)
    table_data = hcat(
        [c["name"] for c in coins],
        [c["symbol"] for c in coins],
        ["\$" * string(round(c["current_price"], digits=2)) for c in coins],
        ["\$" * string(round(c["market_cap"]/1e9, digits=2)) * "B" for c in coins]
    )
    
    pretty_table(table_data, header=["Name", "Symbol", "Price (USD)", "Market Cap (USD)"])
end

# Plot historical price data
function plot_price_history(coin_id::String, coin_name::String)
    data = fetch_historical_prices(coin_id)
    timestamps = [unix2datetime(d[1] ÷ 1000) for d in data]
    prices = [d[2] for d in data]
    plot(timestamps, prices, lw=2, label=coin_name, 
         xlabel="Date", ylabel="Price (USD)", 
         title="7-Day Price History: $coin_name")
end

# ========== Main ==========

# Fetch and display top 5 cryptos
coins = fetch_top_cryptos(5)
println("\n📊 Top 5 Cryptocurrencies:")
show_table(coins)

# Plot historical data for the top coin
selected = coins[1]["id"]
selected_name = coins[1]["name"]
println("\n📈 Fetching historical price data for: $selected_name")
plot_price_history(selected, selected_name)