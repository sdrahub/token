import React, { useState } from "react";
import {token, canisterId,createActor} from "../../../declarations/token";
import { AuthClient } from "@dfinity/auth-client";

function Faucet(props) {

  const [isDisabled, setDisable] = useState(false);
  const [buttonText, setText]=useState("Gimme gimm");

  async function handleClick(event) {
    setDisable(true);

  // set authentication
  const authClient = await AuthClient.create();
  const identity = await authClient.getIdentity();
const authenticatedCanister = createActor(canisterId,{
  agentOption:{
    identity,
  },
});


 //const result = await token.payOut(); // without auth
 const result = await authenticatedCanister.payOut();
 setText(result);
 //setDisable(false);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free Jojo tokens here! Claim 10,000 JOJO token to {props.userPrincipal}.</label>
      <p className="trade-buttons">
        <button 
        id="btn-payout" 
        onClick={handleClick}
        disabled={isDisabled}
        >
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
