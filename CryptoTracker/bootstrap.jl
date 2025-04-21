(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using CryptoTracker
const UserApp = CryptoTracker
CryptoTracker.main()
