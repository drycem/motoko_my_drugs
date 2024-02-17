import Hash "mo:base/Hash";
import Map "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor Assistant{
  type Drug = {
    qrcode: Text;
    expired: Bool;
  };

  func natHash (n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
  };

  var drugs = Map.HashMap<Nat, Drug>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public query func addDrug(qrcode: Text, shelf_no: Text) : async Nat {
    let id = nextId;
    drugs.put(id, {qrcode = qrcode; expired = false });
    nextId += 1;
    id
  };

  public func setExpiredDrug(id: Nat): async () {
    ignore do ? {
      let qrcode = drugs.get(id)!.qrcode;
      drugs.put(id, {qrcode; expired = true});
    }
  };

  public query func showDrugs() : async Text {
    var output: Text = "\nMy Drugs\n________";
    for (drug: Drug in drugs.vals()) {
      output #= "\n" # drug.qrcode;
      if (drug.expired) {output #= " !EXPIRED";};
    };
    output # "\n"
  };
}
