### Power Market Project

Some minimal examples of linear programming used for Power Market Simulations.

#### Nordic Market Simulation

The day-ahead electricity spot market, Elspot, is the main platform to trade electricity in the Nordic region. Here, electricity suppliers and buyers place their bids a day in advance for delivery of electricity during the next day. In this exercise, you will simulate such a market, but with a few simplifications and assumptions as follows:
- You will use a single-auction bidding strategy and simulate for only one hour.
- Generators are assumed to bid their actual marginal costs.
- There is a tie-line connecting Sweden and Poland that is assumed to behave as a load (on Sweden side) of 600MW.
- Estonia is not a participant in this market.

#### Auction Market Simulation

Develop a program to simulate this double-auction market with the objective function being maximization of the social welfare for a single hour.

#### Retailer planning model

Develop and implement a planning model of the electricity retailer in GAMS to help the trading team make the necessary decisions.
