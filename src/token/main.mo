import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
  Debug.print("hello");

  // set the owner
  let owner : Principal = Principal.fromText("35yia-pdpmy-rjm3x-mydyl-576z7-bxahi-6nfzm-l2tri-sx5id-md7ro-aqe");
  let totalSupply : Nat = 1000000000;
  let symbol : Text = "JOJO";

  // make Hashmap stable n private
  private stable var balanceEntries : [(Principal, Nat)] = [];

  //make ledger using HashMap for first entry n can't modify
  private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
  if (balances.size() < 1) {
    // put owner into balances
    balances.put(owner, totalSupply);
  };

  // check balance
  public query func balanceOf(who : Principal) : async Nat {
    let balance : Nat = switch (balances.get(who)) {
      case null 0;
      case (?result) result;
    };
    return balance;
  };

  //give symbol currency
  public query func getSymbol() : async Text {
    return symbol;
  };

  public shared (msg) func payOut() : async Text {
    Debug.print(debug_show (msg.caller));
    if (balances.get(msg.caller) == null) {
      let amount = 10000;
      let result = await transfer(msg.caller, amount); // transfer amount from principal
      return result;
    } else {
      return "Already claimed";
    };
  };

  public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
    let fromBalance = await balanceOf(msg.caller);
    if (fromBalance > amount) {
      // subtract balance from sender
      let newFromBalance : Nat = fromBalance -amount;
      balances.put(msg.caller, newFromBalance);

      // transfer balance to recipient
      let toBalance = await balanceOf(to);
      let newToBalance = toBalance + amount;
      balances.put(to, newToBalance);

      return "Success";
    } else {
      return "Insufficient Fund";
    };
  };

  //make hashmap become stable, modify balances
  system func preupgrade() {
    balanceEntries := Iter.toArray(balances.entries());
  };

  // to get value back
  system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
      // put owner into balances
      balances.put(owner, totalSupply);
    };
  };

};
