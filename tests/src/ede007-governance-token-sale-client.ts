import {
  Tx,
  Chain,
  Account,
  types,
  ReadOnlyFn,
} from "https://deno.land/x/clarinet@v0.28.1/index.ts";

export enum EDE007GovernanceTokenSaleErrCode {
  err_unauthorised=3000,
  err_no_allowance=3001,
  err_already_claimed=3002
}

export class EDE007GovernanceTokenSaleClient {
  contractName = "";
  chain: Chain;
  deployer: Account;

  constructor(chain: Chain, deployer: Account, contractName: string) {
    this.contractName = contractName;
    this.chain = chain;
    this.deployer = deployer;
  }

  setAllowanceStartHeight(height: number, txSender: string): Tx {
    return Tx.contractCall(
      this.contractName,
      "set-allowance-start-height",
      [types.uint(height)], txSender);
  }

  getDeveloperAllowance(who: string): ReadOnlyFn {
    return this.callReadOnlyFn("get-developer-allowance", [types.principal(who)]);
  }

  private callReadOnlyFn(
    method: string,
    args: Array<any> = [],
    sender: Account = this.deployer
  ): ReadOnlyFn {
    const result = this.chain.callReadOnlyFn(
      this.contractName,
      method,
      args,
      sender?.address
    );

    return result;
  }
}
