# Business problem and scope

## Project title
Laptop & RAM Price Intelligence: Memory Affordability and Upgrade Candidate Analysis

## Business persona
An Indian electronics retailer, laptop category manager, or laptop repair/upgrade service wants to understand advertised laptop configurations and RAM-module prices so it can compare listed products, identify possible upgrade candidates, and monitor price changes over time.

## Questions this dataset can answer now
1. How do laptop listing prices vary by brand and installed RAM capacity?
2. Which listings report more supported RAM than installed RAM?
3. Which RAM generations and module form factors appear in the collected catalogue?
4. How do listed RAM module prices per GB vary by generation, capacity and form factor?
5. Which listings have a wide stated low-to-high price range?
6. Which laptop/module pairs are possible upgrade candidates based on matching RAM generation and SO-DIMM indicators?

## Important limits
- The supplied CSVs are one collection, not a genuine time series. No capture date column exists.
- Lowest Price and Highest Price are website-supplied range fields. Their exact reference window/method is not in these CSVs. Call the difference a listed price range/spread, not measured volatility.
- No sales, clicks, conversions, inventory, stock-outs, cost of goods, returns, margin or customer records are present.
- Maximum RAM and RAM technology text are not enough to prove compatibility. Laptop slots, soldered memory, module rank, supported speed, BIOS and OEM model-specific rules must be checked.
- A price-per-GB ratio is a descriptive indicator, not a complete value or performance score.

## Current market context
A September 30, 2026 TrendForce outlook reported strong AI-server demand and projected conventional DRAM contract-price growth in Q4 2026. This provides context for monitoring memory affordability; the uploaded retail listings do not independently prove a global DRAM shortage or its cause.
