import time
from typing import Dict, List, Optional
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
import requests

app = FastAPI(title="CryptoScope API", version="1.0.0")

# Enable CORS for Flutter web / desktop / mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mock fallback dataset for reliable responses
MOCK_COINS = [
    {
        "id": "bitcoin",
        "symbol": "BTC",
        "name": "Bitcoin",
        "rank": 1,
        "price": 64250.80,
        "change24h": 3.45,
        "volume24h": "$34.8B",
        "marketCap": "$1.26T",
        "circulatingSupply": "19.75M BTC",
        "allTimeHigh": 73750.07,
        "sparklinePoints": [62100.0, 62400.0, 62000.0, 62800.0, 63100.0, 63700.0, 64250.80],
        "rangeData": {
            "1H": [64100.0, 64150.0, 64080.0, 64200.0, 64180.0, 64250.80],
            "1D": [62100.0, 62500.0, 61900.0, 63200.0, 63800.0, 64250.80],
            "1W": [58900.0, 60100.0, 61200.0, 60800.0, 63000.0, 64250.80],
            "1M": [54000.0, 56500.0, 59000.0, 61500.0, 62000.0, 64250.80],
            "1Y": [27000.0, 35000.0, 42000.0, 52000.0, 68000.0, 64250.80],
        },
        "isStarred": True,
    },
    {
        "id": "ethereum",
        "symbol": "ETH",
        "name": "Ethereum",
        "rank": 2,
        "price": 3480.20,
        "change24h": 2.18,
        "volume24h": "$18.4B",
        "marketCap": "$418.5B",
        "circulatingSupply": "120.2M ETH",
        "allTimeHigh": 4891.70,
        "sparklinePoints": [3400.0, 3410.0, 3390.0, 3440.0, 3450.0, 3470.0, 3480.20],
        "rangeData": {
            "1H": [3470.0, 3475.0, 3472.0, 3478.0, 3480.20],
            "1D": [3400.0, 3420.0, 3390.0, 3450.0, 3480.20],
            "1W": [3200.0, 3300.0, 3350.0, 3400.0, 3480.20],
            "1M": [2900.0, 3100.0, 3300.0, 3250.0, 3480.20],
            "1Y": [1600.0, 2100.0, 2800.0, 3500.0, 3480.20],
        },
        "isStarred": True,
    },
    {
        "id": "solana",
        "symbol": "SOL",
        "name": "Solana",
        "rank": 3,
        "price": 145.60,
        "change24h": -1.85,
        "volume24h": "$4.2B",
        "marketCap": "$68.1B",
        "circulatingSupply": "467.8M SOL",
        "allTimeHigh": 260.06,
        "sparklinePoints": [149.0, 148.0, 147.5, 146.2, 147.0, 145.6],
        "rangeData": {
            "1H": [146.5, 146.2, 146.0, 145.8, 145.6],
            "1D": [149.0, 147.8, 148.2, 146.0, 145.6],
            "1W": [135.0, 140.0, 148.0, 150.0, 145.6],
            "1M": [120.0, 130.0, 145.0, 155.0, 145.6],
            "1Y": [20.0, 45.0, 95.0, 180.0, 145.6],
        },
        "isStarred": False,
    },
    {
        "id": "tether",
        "symbol": "USDT",
        "name": "Tether",
        "rank": 4,
        "price": 1.0002,
        "change24h": 0.01,
        "volume24h": "$42.1B",
        "marketCap": "$118.2B",
        "circulatingSupply": "118.2B USDT",
        "allTimeHigh": 1.32,
        "sparklinePoints": [1.0, 1.0001, 1.0, 1.0003, 1.0002],
        "rangeData": {
            "1H": [1.0, 1.0001, 1.0002],
            "1D": [1.0, 1.0003, 1.0002],
            "1W": [0.9998, 1.0004, 1.0002],
            "1M": [0.9995, 1.0005, 1.0002],
            "1Y": [0.9980, 1.0020, 1.0002],
        },
        "isStarred": False,
    },
    {
        "id": "binancecoin",
        "symbol": "BNB",
        "name": "BNB",
        "rank": 5,
        "price": 578.40,
        "change24h": 4.12,
        "volume24h": "$1.9B",
        "marketCap": "$84.5B",
        "circulatingSupply": "146.1M BNB",
        "allTimeHigh": 720.67,
        "sparklinePoints": [550.0, 555.0, 560.0, 565.0, 572.0, 578.40],
        "rangeData": {
            "1H": [575.0, 576.0, 578.0, 578.40],
            "1D": [550.0, 560.0, 570.0, 578.40],
            "1W": [520.0, 540.0, 565.0, 578.40],
            "1M": [480.0, 510.0, 550.0, 578.40],
            "1Y": [210.0, 320.0, 590.0, 578.40],
        },
        "isStarred": True,
    },
    {
        "id": "ripple",
        "symbol": "XRP",
        "name": "XRP",
        "rank": 6,
        "price": 0.5620,
        "change24h": -3.40,
        "volume24h": "$2.1B",
        "marketCap": "$31.4B",
        "circulatingSupply": "56.1B XRP",
        "allTimeHigh": 3.84,
        "sparklinePoints": [0.585, 0.580, 0.575, 0.570, 0.562],
        "rangeData": {
            "1H": [0.565, 0.564, 0.562],
            "1D": [0.585, 0.575, 0.562],
            "1W": [0.540, 0.610, 0.562],
            "1M": [0.480, 0.590, 0.562],
            "1Y": [0.450, 0.650, 0.562],
        },
        "isStarred": False,
    },
    {
        "id": "cardano",
        "symbol": "ADA",
        "name": "Cardano",
        "rank": 7,
        "price": 0.3850,
        "change24h": 1.15,
        "volume24h": "$410M",
        "marketCap": "$13.8B",
        "circulatingSupply": "35.8B ADA",
        "allTimeHigh": 3.10,
        "sparklinePoints": [0.378, 0.380, 0.382, 0.381, 0.385],
        "rangeData": {
            "1H": [0.384, 0.385],
            "1D": [0.378, 0.381, 0.385],
            "1W": [0.350, 0.370, 0.385],
            "1M": [0.320, 0.360, 0.385],
            "1Y": [0.240, 0.450, 0.385],
        },
        "isStarred": False,
    },
    {
        "id": "dogecoin",
        "symbol": "DOGE",
        "name": "Dogecoin",
        "rank": 8,
        "price": 0.1240,
        "change24h": -5.22,
        "volume24h": "$890M",
        "marketCap": "$18.1B",
        "circulatingSupply": "145.8B DOGE",
        "allTimeHigh": 0.7376,
        "sparklinePoints": [0.131, 0.129, 0.128, 0.125, 0.124],
        "rangeData": {
            "1H": [0.125, 0.124],
            "1D": [0.131, 0.127, 0.124],
            "1W": [0.115, 0.135, 0.124],
            "1M": [0.100, 0.140, 0.124],
            "1Y": [0.060, 0.180, 0.124],
        },
        "isStarred": False,
    },
]

def format_large_number(num: Optional[float]) -> str:
    if not num:
        return "N/A"
    if num >= 1e12:
        return f"${num / 1e12:.2f}T"
    if num >= 1e9:
        return f"${num / 1e9:.2f}B"
    if num >= 1e6:
        return f"${num / 1e6:.2f}M"
    return f"${num:,.2f}"

def fetch_coingecko_coins():
    try:
        url = (
            "https://api.coingecko.com/api/v3/coins/markets"
            "?vs_currency=usd&order=market_cap_desc&per_page=12&page=1&sparkline=true"
        )
        headers = {"User-Agent": "CryptoScopeApp/1.0"}
        resp = requests.get(url, headers=headers, timeout=4)
        if resp.status_code == 200:
            data = resp.json()
            coins = []
            for item in data:
                spark_points = []
                if "sparkline_in_7d" in item and "price" in item["sparkline_in_7d"]:
                    raw_pts = item["sparkline_in_7d"]["price"]
                    # Downsample to ~8 points for fast chart rendering
                    step = max(1, len(raw_pts) // 8)
                    spark_points = [float(p) for p in raw_pts[::step]]
                
                price = float(item.get("current_price") or 0.0)
                change = float(item.get("price_change_percentage_24h") or 0.0)
                
                coins.append({
                    "id": item.get("id"),
                    "symbol": item.get("symbol", "").upper(),
                    "name": item.get("name"),
                    "rank": item.get("market_cap_rank") or 99,
                    "price": price,
                    "change24h": change,
                    "volume24h": format_large_number(item.get("total_volume")),
                    "marketCap": format_large_number(item.get("market_cap")),
                    "circulatingSupply": f"{format_large_number(item.get('circulating_supply')).replace('$', '')} {item.get('symbol', '').upper()}",
                    "allTimeHigh": float(item.get("ath") or price * 1.2),
                    "sparklinePoints": spark_points if spark_points else [price * 0.95, price * 1.02, price],
                    "rangeData": {
                        "1H": [price * 0.998, price * 1.001, price],
                        "1D": [price * (1 - change/100), price * 1.01, price],
                        "1W": [price * 0.92, price * 1.05, price],
                        "1M": [price * 0.85, price * 1.10, price],
                        "1Y": [price * 0.50, price * 1.40, price],
                    },
                    "isStarred": False,
                })
            return coins
    except Exception as e:
        print(f"[FastAPI Warning] CoinGecko fetch exception: {e}")
    return MOCK_COINS

@app.get("/")
def read_root():
    return {"app": "CryptoScope API", "status": "online", "timestamp": time.time()}

@app.get("/api/coins")
def get_coins(search: Optional[str] = None):
    coins = fetch_coingecko_coins()
    if search:
        query = search.lower().strip()
        coins = [c for c in coins if query in c["name"].lower() or query in c["symbol"].lower() or query in c["id"].lower()]
    return coins

@app.get("/api/coins/{coin_id}")
def get_coin_detail(coin_id: str, range: Optional[str] = "1D"):
    coins = fetch_coingecko_coins()
    matched = next((c for c in coins if c["id"] == coin_id or c["symbol"].lower() == coin_id.lower()), None)
    if not matched:
        # Fallback search in mock
        matched = next((c for c in MOCK_COINS if c["id"] == coin_id or c["symbol"].lower() == coin_id.lower()), MOCK_COINS[0])
    
    # Return matched detail with requested range chart points
    range_key = range.upper() if range else "1D"
    points = matched.get("rangeData", {}).get(range_key, matched.get("sparklinePoints", []))
    
    response = dict(matched)
    response["activeRange"] = range_key
    response["chartPoints"] = points
    return response

@app.get("/api/market/stats")
def get_market_stats():
    coins = fetch_coingecko_coins()
    total_cap = sum(c.get("price", 0) for c in coins) * 10000000
    
    # Sort gainers and losers
    gainers = sorted(coins, key=lambda x: x.get("change24h", 0), reverse=True)[:3]
    losers = sorted(coins, key=lambda x: x.get("change24h", 0))[:2]
    
    return {
        "totalMarketCap": "$2.42 Trillion",
        "marketCapChange24h": 3.45,
        "dominance": [
            {"label": "BTC", "percentage": 54.2, "color": "#F7931A"},
            {"label": "ETH", "percentage": 16.8, "color": "#627EEA"},
            {"label": "Others", "percentage": 29.0, "color": "#2FB88A"}
        ],
        "topGainers": gainers,
        "topLosers": losers
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
