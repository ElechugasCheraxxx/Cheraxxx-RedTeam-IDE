use logos::Logos;
use serde::{Deserialize, Serialize};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

pub mod ast;
pub mod protocol;
pub mod parser;
pub mod codegen_cpp;

#[derive(Logos, Debug, PartialEq, Clone)]
#[logos(skip r"[ \t\n\f]+")] // Skip whitespace
#[logos(skip r"//.*")]        // Skip comments
pub enum Token {
    // Keywords
    #[token("mission")]
    Mission,
    #[token("agent")]
    Agent,
    #[token("verify")]
    Verify,
    #[token("swarm")]
    Swarm,
    #[token("flow")]
    Flow,
    #[token("step")]
    Step,
    #[token("link")]
    Link,
    #[token("resource")]
    Resource,
    #[token("invariant")]
    Invariant,
    #[token("precondition")]
    Precondition,
    #[token("postcondition")]
    Postcondition,
    #[token("on_success")]
    OnSuccess,
    #[token("on_fail")]
    OnFail,
    #[token("strict_limit")]
    StrictLimit,
    #[token("buffer")]
    Buffer,
    #[token("choreography")]
    Choreography,
    #[token("phase")]
    Phase,
    #[token("swarm_sync")]
    SwarmSync,
    #[token("on_event")]
    OnEvent,
    #[token("bind")]
    Bind,
    #[token("await")]
    Await,
    #[token("lock")]
    Lock,
    #[token("assert")]
    Assert,
    #[token("purge")]
    Purge,
    #[token("halt")]
    Halt,
    #[token("commit")]
    Commit,
    #[token("resume")]
    Resume,

    // Directives
    #[token("@compiler")]
    CompilerDirective,
    #[token("@memory_pool")]
    MemoryPoolDirective,
    #[token("@alignment")]
    AlignmentDirective,
    #[token("@temporal_drift")]
    TemporalDriftDirective,

    // Symbols
    #[token("{")]
    BraceOpen,
    #[token("}")]
    BraceClose,
    #[token("[")]
    BracketOpen,
    #[token("]")]
    BracketClose,
    #[token("(")]
    ParenOpen,
    #[token(")")]
    ParenClose,
    #[token(":")]
    Colon,
    #[token(";")]
    Semicolon,
    #[token("->")]
    Arrow,
    #[token("==")]
    Equals,
    #[token("if")]
    If,
    #[token("when")]
    When,

    // Identifiers and Literals
    #[regex(r#""([^"\\]|\\.)*""#, |lex| lex.slice().to_string())]
    String(String),
    #[regex(r"[a-zA-Z_][a-zA-Z0-9_]*(::[a-zA-Z_][a-zA-Z0-9_]*)*", |lex| lex.slice().to_string())]
    Ident(String),
    #[regex(r"[0-9]+(\.[0-9]+)?(KB|MB|GB|B|ms|s|C)?", |lex| lex.slice().to_string())]
    Literal(String),

    #[token("<")]
    Less,
    #[token(">")]
    Greater,
    #[token("<=")]
    LessEqual,
    #[token(">=")]
    GreaterEqual,
}

#[no_mangle]
pub extern "C" fn chrx_compile_mission(input: *const c_char) -> *mut c_char {
    if input.is_null() { return std::ptr::null_mut(); }

    let c_str = unsafe { CStr::from_ptr(input) };
    let input_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => return std::ptr::null_mut(),
    };

    let mut parser = parser::Parser::new(input_str);
    match parser.parse_mission() {
        Ok(mission) => {
            let mut gen = codegen_cpp::CppGenerator::new();
            match gen.generate(&mission) {
                Ok(code) => {
                    let c_code = CString::new(code).unwrap();
                    c_code.into_raw()
                }
                Err(_) => std::ptr::null_mut(),
            }
        }
        Err(_) => std::ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn chrx_free_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe { drop(CString::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn chrx_generate_pdg_json(input: *const c_char) -> *mut c_char {
    if input.is_null() { return std::ptr::null_mut(); }

    let c_str = unsafe { CStr::from_ptr(input) };
    let input_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => return std::ptr::null_mut(),
    };

    let mut parser = parser::Parser::new(input_str);
    match parser.parse_mission() {
        Ok(mission) => {
            let json = serde_json::to_string(&mission).unwrap_or_default();
            let c_json = CString::new(json).unwrap();
            c_json.into_raw()
        }
        Err(_) => std::ptr::null_mut(),
    }
}

pub struct Lexer<'a> {
    inner: logos::Lexer<'a, Token>,
}

impl<'a> Lexer<'a> {
    pub fn new(input: &'a str) -> Self {
        Self {
            inner: Token::lexer(input),
        }
    }
}

impl<'a> Iterator for Lexer<'a> {
    type Item = Result<Token, ()>;

    fn next(&mut self) -> Option<Self::Item> {
        self.inner.next()
    }
}
