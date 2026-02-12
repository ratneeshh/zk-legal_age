

#  ZK Legal Age Proof — Commands Reference

This document lists all commands required to compile, setup, prove, and verify the circuit.

---

# Setup (Run After Modifying Circuit)

---

## 1️ Clean Old Outputs

```bash
rm -r outputs/*
```

**Purpose:**
Removes previously generated files (r1cs, wasm, zkey, proofs).

---

## 2️ Compile Circuit

```bash
circom circuits/legal_age.circom \
--r1cs --wasm --sym \
-o outputs \
-l node_modules
```

**Purpose:**
Generates:

* `.r1cs` → constraint system
* `.wasm` → witness generator
* `.sym` → debug symbols

---

## 3️ Download Powers of Tau (If Not Present)

```bash
wget https://storage.googleapis.com/zkevm/ptau/powersOfTau28_hez_final_10.ptau \
-O outputs/pot10.ptau
```

**Purpose:**
Downloads trusted setup file required for Groth16.

---

## 4️ Generate ZKey (Trusted Setup)

```bash
snarkjs groth16 setup \
outputs/legal_age.r1cs \
outputs/pot10.ptau \
outputs/legal_age_final.zkey
```

**Purpose:**
Creates proving key (`.zkey`) from circuit.

---

## 5️ Export Verification Key

```bash
snarkjs zkey export verificationkey \
outputs/legal_age_final.zkey \
outputs/verification_key.json
```

**Purpose:**
Generates verification key used to verify proofs.

---

#  Proving Flow (For Each Input)

---

## 6️ Generate Witness

```bash
node outputs/legal_age_js/generate_witness.js \
outputs/legal_age_js/legal_age.wasm \
inputs/input.json \
outputs/witness.wtns
```

**Purpose:**
Computes witness using private inputs.
Fails if age < 18.

---

## 7️ Generate Proof

```bash
snarkjs groth16 prove \
outputs/legal_age_final.zkey \
outputs/witness.wtns \
outputs/proof.json \
outputs/public.json
```

**Purpose:**
Generates:

* `proof.json` → zk proof
* `public.json` → public output

---

## 8️ Verify Proof

```bash
snarkjs groth16 verify \
outputs/verification_key.json \
outputs/public.json \
outputs/proof.json
```

**Purpose:**
Verifies proof validity.
Outputs `OK!` if valid.

---

# Expected Behaviour

* If age < 18 → witness generation fails
* If age ≥ 18 → proof generated
* Valid proof → `OK!`

---

**Author:** Ratnesh
