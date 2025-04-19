using HTTP, JSON3

# API endpoint for top cryptocurrencies (by market cap)
url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=5&page=1"

# Make the request
response = HTTP.get(url)

# Parse the JSON response
data = JSON3.read(String(response.body))

# Display results
for coin in data
    println("🪙 Name: ", coin["name"])
    println("💲 Price: \$", coin["current_price"])
    println("📈 Market Cap: \$", coin["market_cap"])
    println("🔗 Link: https://www.coingecko.com/en/coins/", coin["id"])
    println("────────────────────────────")
end
