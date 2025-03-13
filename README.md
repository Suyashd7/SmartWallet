# SmartWallet

SmartWallet is a secure multi-signature wallet that allows the owner to manage funds with guardians and set allowances for other addresses. It supports:

Owner & Guardianship: The owner can set guardians who can propose a new owner. The change requires approval from multiple guardians.
Allowance System: The owner can set spending limits for addresses, controlling how much they can send.
Secure Fund Transfers: Transfers can be made by the owner or allowed addresses, within their spending limits.
Propose New Owner: Guardians can vote to change the owner after a certain number of confirmations.
Receive Funds: The contract can accept ether directly.
The consumer contract interacts with the SmartWallet, allowing you to check the balance and deposit funds.

Let me know if you'd like to mod
