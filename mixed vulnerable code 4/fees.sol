Rust
if fee != U256::from(0) {
    let relayer_address = unwrap_res_or_finish!(
        self.get_relayer(relayer_account_id.as_bytes()).ok_or(()),
        output_on_fail,
        self.io
    );

    unwrap_res_or_finish!(
        self.transfer(
            recipient,
            relayer_address,
            Wei::new_u64(fee.as_u64()),
            u64::MAX,
            handler,
        ),
        output_on_fail,
        self.io
    );
}

// SNIP 
// MINT ERC20 to recipient
//–the vulnerability in the logic explained in the previous section. As you may have noticed,
// the &args value is totally under the control of the attacker. A malicious user could perform the
// following step-by-step attack scenario:

//1. Create a NEP-141 -> ERC20 mapping prior to carrying out the attack. 
//This is a permissionless operation so the attacker faces no barriers.

//2. Transfer their NEP-141 token (which is worthless) to their victim, 
//specifying U64_MAX as the fee in the msg field of the args value. 
//Their address will be that of the message relayer in this case since signer_account_id() will be the attacker’s
// NEAR account’s address.

//3. Receive funds from the recipient to their NEAR account