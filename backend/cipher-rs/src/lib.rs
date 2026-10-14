use pqcrypto_mlkem::mlkem768::{
    keypair, encapsulate, decapsulate, PublicKey, SecretKey, Ciphertext
};
use pqcrypto_mldsa::mldsa65::{
    keypair as dsa_keypair, detached_sign as sign, verify_detached_signature as verify, PublicKey as DsaPublicKey, SecretKey as DsaSecretKey, DetachedSignature
};
use pqcrypto_traits::kem::{
    PublicKey as _, SecretKey as _, Ciphertext as _, SharedSecret as _
};
use pqcrypto_traits::sign::{
    PublicKey as _, SecretKey as _, DetachedSignature as _
};
use std::slice;

#[repr(C)]
pub struct PqcKeyPair {
    pub pk: *mut u8,
    pub pk_len: usize,
    pub sk: *mut u8,
    pub sk_len: usize,
}

#[repr(C)]
pub struct PqcEncapsulation {
    pub ct: *mut u8,
    pub ct_len: usize,
    pub ss: *mut u8,
    pub ss_len: usize,
}

#[repr(C)]
pub struct PqcSignature {
    pub sig: *mut u8,
    pub sig_len: usize,
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_keygen() -> PqcKeyPair {
    let (pk, sk) = keypair();
    // kyber768 pk is 1184, sk is 2400
    let pk_vec = pqcrypto_traits::kem::PublicKey::as_bytes(&pk).to_vec();
    let sk_vec = pqcrypto_traits::kem::SecretKey::as_bytes(&sk).to_vec();

    PqcKeyPair {
        pk_len: pk_vec.len(),
        pk: Box::into_raw(pk_vec.into_boxed_slice()) as *mut u8,
        sk_len: sk_vec.len(),
        sk: Box::into_raw(sk_vec.into_boxed_slice()) as *mut u8,
    }
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_free_keypair(kp: PqcKeyPair) {
    unsafe {
        if !kp.pk.is_null() {
            let _ = Box::from_raw(slice::from_raw_parts_mut(kp.pk, kp.pk_len));
        }
        if !kp.sk.is_null() {
            let _ = Box::from_raw(slice::from_raw_parts_mut(kp.sk, kp.sk_len));
        }
    }
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_encapsulate(pk_ptr: *const u8, pk_len: usize) -> PqcEncapsulation {
    if pk_ptr.is_null() && pk_len > 0 {
        return PqcEncapsulation { ct: std::ptr::null_mut(), ct_len: 0, ss: std::ptr::null_mut(), ss_len: 0 };
    }
    let pk_slice = unsafe { slice::from_raw_parts(pk_ptr, pk_len) };
    let pk = match PublicKey::from_bytes(pk_slice) {
        Ok(pk) => pk,
        Err(_) => return PqcEncapsulation { ct: std::ptr::null_mut(), ct_len: 0, ss: std::ptr::null_mut(), ss_len: 0 },
    };

    // pqcrypto-mlkem returns (SharedSecret, Ciphertext)
    let (ss, ct) = encapsulate(&pk);

    let ct_vec = pqcrypto_traits::kem::Ciphertext::as_bytes(&ct).to_vec();
    let ss_vec = pqcrypto_traits::kem::SharedSecret::as_bytes(&ss).to_vec();

    PqcEncapsulation {
        ct_len: ct_vec.len(),
        ct: Box::into_raw(ct_vec.into_boxed_slice()) as *mut u8,
        ss_len: ss_vec.len(),
        ss: Box::into_raw(ss_vec.into_boxed_slice()) as *mut u8,
    }
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_free_encapsulation(res: PqcEncapsulation) {
    unsafe {
        if !res.ct.is_null() {
            let _ = Box::from_raw(slice::from_raw_parts_mut(res.ct, res.ct_len));
        }
        if !res.ss.is_null() {
            let _ = Box::from_raw(slice::from_raw_parts_mut(res.ss, res.ss_len));
        }
    }
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_decapsulate(ct_ptr: *const u8, ct_len: usize, sk_ptr: *const u8, sk_len: usize) -> *mut u8 {
    if (ct_ptr.is_null() && ct_len > 0) || (sk_ptr.is_null() && sk_len > 0) {
        return std::ptr::null_mut();
    }
    let ct_slice = unsafe { slice::from_raw_parts(ct_ptr, ct_len) };
    let sk_slice = unsafe { slice::from_raw_parts(sk_ptr, sk_len) };

    let ct = match Ciphertext::from_bytes(ct_slice) {
        Ok(ct) => ct,
        Err(_) => return std::ptr::null_mut(),
    };
    let sk = match SecretKey::from_bytes(sk_slice) {
        Ok(sk) => sk,
        Err(_) => return std::ptr::null_mut(),
    };

    let ss = decapsulate(&ct, &sk);
    let ss_vec = pqcrypto_traits::kem::SharedSecret::as_bytes(&ss).to_vec();
    Box::into_raw(ss_vec.into_boxed_slice()) as *mut u8
}

#[no_mangle]
pub extern "C" fn rust_mlkem768_free_buffer(ptr: *mut u8, len: usize) {
    if !ptr.is_null() {
        unsafe {
            let _ = Box::from_raw(slice::from_raw_parts_mut(ptr, len));
        }
    }
}

#[no_mangle]
pub extern "C" fn rust_mldsa65_keygen() -> PqcKeyPair {
    let (pk, sk) = dsa_keypair();
    let pk_vec = pqcrypto_traits::sign::PublicKey::as_bytes(&pk).to_vec();
    let sk_vec = pqcrypto_traits::sign::SecretKey::as_bytes(&sk).to_vec();

    PqcKeyPair {
        pk_len: pk_vec.len(),
        pk: Box::into_raw(pk_vec.into_boxed_slice()) as *mut u8,
        sk_len: sk_vec.len(),
        sk: Box::into_raw(sk_vec.into_boxed_slice()) as *mut u8,
    }
}

#[no_mangle]
pub extern "C" fn rust_mldsa65_sign(msg_ptr: *const u8, msg_len: usize, sk_ptr: *const u8, sk_len: usize) -> PqcSignature {
    if (msg_ptr.is_null() && msg_len > 0) || (sk_ptr.is_null() && sk_len > 0) {
        return PqcSignature { sig: std::ptr::null_mut(), sig_len: 0 };
    }
    let msg = unsafe { slice::from_raw_parts(msg_ptr, msg_len) };
    let sk_slice = unsafe { slice::from_raw_parts(sk_ptr, sk_len) };

    let sk = match DsaSecretKey::from_bytes(sk_slice) {
        Ok(sk) => sk,
        Err(_) => return PqcSignature { sig: std::ptr::null_mut(), sig_len: 0 },
    };

    let sig = sign(msg, &sk);
    let sig_vec = pqcrypto_traits::sign::DetachedSignature::as_bytes(&sig).to_vec();

    PqcSignature {
        sig_len: sig_vec.len(),
        sig: Box::into_raw(sig_vec.into_boxed_slice()) as *mut u8,
    }
}

#[no_mangle]
pub extern "C" fn rust_mldsa65_free_signature(sig: PqcSignature) {
    unsafe {
        if !sig.sig.is_null() {
            let _ = Box::from_raw(slice::from_raw_parts_mut(sig.sig, sig.sig_len));
        }
    }
}

#[no_mangle]
pub extern "C" fn rust_mldsa65_verify(msg_ptr: *const u8, msg_len: usize, sig_ptr: *const u8, sig_len: usize, pk_ptr: *const u8, pk_len: usize) -> bool {
    if (msg_ptr.is_null() && msg_len > 0) || (sig_ptr.is_null() && sig_len > 0) || (pk_ptr.is_null() && pk_len > 0) {
        return false;
    }
    let msg = unsafe { slice::from_raw_parts(msg_ptr, msg_len) };
    let sig_slice = unsafe { slice::from_raw_parts(sig_ptr, sig_len) };
    let pk_slice = unsafe { slice::from_raw_parts(pk_ptr, pk_len) };

    let sig = match DetachedSignature::from_bytes(sig_slice) {
        Ok(s) => s,
        Err(_) => return false,
    };
    let pk = match DsaPublicKey::from_bytes(pk_slice) {
        Ok(p) => p,
        Err(_) => return false,
    };

    verify(&sig, msg, &pk).is_ok()
}

#[no_mangle]
pub extern "C" fn rust_mldsa65_free_keypair(kp: PqcKeyPair) {
    rust_mlkem768_free_keypair(kp);
}

// --- Data Surgery Engine (Rust Edition) ---

use regex::Regex;
use std::fs::File;
use std::io::Read;
use std::ffi::{CStr, CString};
use libc::c_char;

#[repr(C)]
pub struct SurgeryResult {
    pub data: *mut c_char,
    pub length: usize,
}

#[no_mangle]
pub extern "C" fn rust_execute_regex_mission(
    input_path_ptr: *const c_char,
    pattern_ptr: *const c_char
) -> SurgeryResult {
    if input_path_ptr.is_null() || pattern_ptr.is_null() {
        let err_msg = "ERROR: Null pointer input".to_string();
        let len = err_msg.len();
        return SurgeryResult {
            data: CString::new(err_msg).map(|c| c.into_raw()).unwrap_or(std::ptr::null_mut()),
            length: len,
        };
    }
    let input_path = unsafe { CStr::from_ptr(input_path_ptr) }.to_string_lossy();
    let pattern = unsafe { CStr::from_ptr(pattern_ptr) }.to_string_lossy();

    let mut result_string = String::new();

    // Implementación optimizada con Regex de Rust
    match Regex::new(&pattern) {
        Ok(re) => {
            // Intentamos abrir el archivo
            if let Ok(mut file) = File::open(input_path.as_ref()) {
                let mut contents = String::new();
                if file.read_to_string(&mut contents).is_ok() {
                    // Buscamos todas las coincidencias
                    for cap in re.captures_iter(&contents) {
                        if let Some(m) = cap.get(0) {
                            result_string.push_str(m.as_str());
                            result_string.push('\n');
                        }
                    }
                } else {
                    result_string = "ERROR: Failed to read file content as UTF-8".to_string();
                }
            } else {
                result_string = format!("ERROR: Could not open file: {}", input_path);
            }
        }
        Err(e) => {
            result_string = format!("ERROR: Invalid Regex Pattern: {}", e);
        }
    }

    if result_string.is_empty() {
        result_string = "NO_MATCHES_FOUND".to_string();
    }

    let c_str = CString::new(result_string).unwrap_or_else(|_| {
        // Safe because the literal has no null bytes
        unsafe { CString::from_vec_unchecked(b"ERROR: Internal String Conversion".to_vec()) }
    });
    let len = c_str.as_bytes().len();

    SurgeryResult {
        data: c_str.into_raw(),
        length: len,
    }
}

#[no_mangle]
pub extern "C" fn rust_free_surgery_result(res: SurgeryResult) {
    if !res.data.is_null() {
        unsafe {
            let _ = CString::from_raw(res.data);
        }
    }
}

// --- Cipher Orchestrator (Rust Maestro) ---

use dashmap::DashMap;
use once_cell::sync::Lazy;
use std::sync::atomic::{AtomicI64, Ordering};
use std::time::{SystemTime, UNIX_EPOCH};

#[repr(C)]
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum RustAgentState {
    Hibernated,
    WakingUp,
    Active,
    Idle,
    Hibernating,
}

pub struct AgentMetadata {
    pub alias: String,
    pub state: RustAgentState,
    pub last_activity: AtomicI64,
}

static ORCHESTRATOR_MAP: Lazy<DashMap<String, AgentMetadata>> = Lazy::new(|| DashMap::new());

fn get_now_micros() -> i64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_micros() as i64
}

#[no_mangle]
pub extern "C" fn rust_orch_register_agent(alias_ptr: *const c_char) {
    if alias_ptr.is_null() { return; }
    let alias = unsafe { CStr::from_ptr(alias_ptr) }.to_string_lossy().into_owned();
    ORCHESTRATOR_MAP.insert(alias.clone(), AgentMetadata {
        alias,
        state: RustAgentState::Hibernated,
        last_activity: AtomicI64::new(get_now_micros()),
    });
}

#[no_mangle]
pub extern "C" fn rust_orch_update_activity(alias_ptr: *const c_char) {
    if alias_ptr.is_null() { return; }
    let alias = unsafe { CStr::from_ptr(alias_ptr) }.to_string_lossy();
    if let Some(agent) = ORCHESTRATOR_MAP.get(alias.as_ref()) {
        agent.last_activity.store(get_now_micros(), Ordering::SeqCst);
    }
}

#[no_mangle]
pub extern "C" fn rust_orch_set_state(alias_ptr: *const c_char, state: RustAgentState) {
    if alias_ptr.is_null() { return; }
    let alias = unsafe { CStr::from_ptr(alias_ptr) }.to_string_lossy();
    if let Some(mut agent) = ORCHESTRATOR_MAP.get_mut(alias.as_ref()) {
        agent.state = state;
    }
}

#[no_mangle]
pub extern "C" fn rust_orch_get_state(alias_ptr: *const c_char) -> RustAgentState {
    if alias_ptr.is_null() { return RustAgentState::Hibernated; }
    let alias = unsafe { CStr::from_ptr(alias_ptr) }.to_string_lossy();
    ORCHESTRATOR_MAP.get(alias.as_ref())
        .map(|a| a.state)
        .unwrap_or(RustAgentState::Hibernated)
}

#[no_mangle]
pub extern "C" fn rust_orch_get_idle_agents(timeout_secs: i64) -> SurgeryResult {
    let now = get_now_micros();
    let mut idle_aliases = Vec::new();

    for entry in ORCHESTRATOR_MAP.iter() {
        let agent = entry.value();
        if agent.state == RustAgentState::Active {
            let last = agent.last_activity.load(Ordering::SeqCst);
            if (now - last) > (timeout_secs * 1_000_000) {
                idle_aliases.push(agent.alias.clone());
            }
        }
    }

    let result_string = idle_aliases.join("|");
    let c_str = CString::new(result_string).unwrap_or_else(|_| {
        unsafe { CString::from_vec_unchecked(b"ERROR".to_vec()) }
    });
    let len = c_str.as_bytes().len();

    SurgeryResult {
        data: c_str.into_raw(),
        length: len,
    }
}

#[no_mangle]
pub extern "C" fn rust_orch_get_active_agents() -> SurgeryResult {
    let mut active_aliases = Vec::new();

    for entry in ORCHESTRATOR_MAP.iter() {
        let agent = entry.value();
        if agent.state == RustAgentState::Active {
            active_aliases.push(agent.alias.clone());
        }
    }

    let result_string = active_aliases.join("|");
    let c_str = CString::new(result_string).unwrap_or_else(|_| {
        unsafe { CString::from_vec_unchecked(b"ERROR".to_vec()) }
    });
    let len = c_str.as_bytes().len();

    SurgeryResult {
        data: c_str.into_raw(),
        length: len,
    }
}
