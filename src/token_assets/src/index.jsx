import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from "@dfinity/auth-client";


const init = async () => { 
 
// to create auth
const authClient = await AuthClient.create();

//to check if already login and bypass login process or login first
if (await authClient.isAuthenticated()){
handleAuthenticated(authClient);
}else{
  await authClient.login({
    idendityProvider :"https://identity.ic0.app/#authorize",
  onSuccess :() => {
    handleAuthenticated(authClient);
  }
  });
}

//to render app components
async function handleAuthenticated(authClient){
  const identity = await authClient.getIdentity();// to get identity ID
  const userPrincipal = identity._principal.toString();
  console.log(userPrincipal);
  ReactDOM.render(<App loggedInPrincipal={userPrincipal}/>, document.getElementById("root"));
}

}

init();


