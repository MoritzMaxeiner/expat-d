module expat;

import core.stdc.config : c_long, c_ulong;

version (XML_UNICODE_WCHAR_T) {
    version = XML_UNICODE;
}

version (XML_UNICODE) {
    version (XML_UNICODE_WCHAR_T) {
        alias XML_Char  = wchar;
        alias XML_LChar = wchar;
    } else {
        alias XML_Char  = ushort;
        alias XML_LChar = char;
    }
} else {
    alias XML_Char  = char;
    alias XML_LChar = char;
}

version (XML_LARGE_SIZE) {
    alias XML_Index = long;
    alias XML_Size  = ulong;
} else {
    alias XML_Index = c_long;
    alias XML_Size  = c_ulong;
}

//

struct XML_ParserStruct {}
alias XML_Parser = XML_ParserStruct*;

alias XML_Bool = bool;

alias XML_Status = uint;
enum : XML_Status {
  XML_STATUS_ERROR = 0,
  XML_STATUS_OK = 1,
  XML_STATUS_SUSPENDED = 2
}

alias XML_Error = uint;
enum : XML_Error {
  XML_ERROR_NONE,
  XML_ERROR_NO_MEMORY,
  XML_ERROR_SYNTAX,
  XML_ERROR_NO_ELEMENTS,
  XML_ERROR_INVALID_TOKEN,
  XML_ERROR_UNCLOSED_TOKEN,
  XML_ERROR_PARTIAL_CHAR,
  XML_ERROR_TAG_MISMATCH,
  XML_ERROR_DUPLICATE_ATTRIBUTE,
  XML_ERROR_JUNK_AFTER_DOC_ELEMENT,
  XML_ERROR_PARAM_ENTITY_REF,
  XML_ERROR_UNDEFINED_ENTITY,
  XML_ERROR_RECURSIVE_ENTITY_REF,
  XML_ERROR_ASYNC_ENTITY,
  XML_ERROR_BAD_CHAR_REF,
  XML_ERROR_BINARY_ENTITY_REF,
  XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF,
  XML_ERROR_MISPLACED_XML_PI,
  XML_ERROR_UNKNOWN_ENCODING,
  XML_ERROR_INCORRECT_ENCODING,
  XML_ERROR_UNCLOSED_CDATA_SECTION,
  XML_ERROR_EXTERNAL_ENTITY_HANDLING,
  XML_ERROR_NOT_STANDALONE,
  XML_ERROR_UNEXPECTED_STATE,
  XML_ERROR_ENTITY_DECLARED_IN_PE,
  XML_ERROR_FEATURE_REQUIRES_XML_DTD,
  XML_ERROR_CANT_CHANGE_FEATURE_ONCE_PARSING,
  /* Added in 1.95.7. */
  XML_ERROR_UNBOUND_PREFIX,
  /* Added in 1.95.8. */
  XML_ERROR_UNDECLARING_PREFIX,
  XML_ERROR_INCOMPLETE_PE,
  XML_ERROR_XML_DECL,
  XML_ERROR_TEXT_DECL,
  XML_ERROR_PUBLICID,
  XML_ERROR_SUSPENDED,
  XML_ERROR_NOT_SUSPENDED,
  XML_ERROR_ABORTED,
  XML_ERROR_FINISHED,
  XML_ERROR_SUSPEND_PE,
  /* Added in 2.0. */
  XML_ERROR_RESERVED_PREFIX_XML,
  XML_ERROR_RESERVED_PREFIX_XMLNS,
  XML_ERROR_RESERVED_NAMESPACE_URI
}

alias XML_Content_Type = uint;
enum : XML_Content_Type {
  XML_CTYPE_EMPTY = 1,
  XML_CTYPE_ANY,
  XML_CTYPE_MIXED,
  XML_CTYPE_NAME,
  XML_CTYPE_CHOICE,
  XML_CTYPE_SEQ
}

alias XML_Content_Quant = uint;
enum : XML_Content_Quant {
  XML_CQUANT_NONE,
  XML_CQUANT_OPT,
  XML_CQUANT_REP,
  XML_CQUANT_PLUS
}

struct XML_Content {
  XML_Content_Type              type;
  XML_Content_Quant             quant;
  XML_Char*                     name;
  uint                          numchildren;
  XML_Content*                  children;
}

alias XML_ElementDeclHandler = extern(C) nothrow void function(void* userData,
                                                                    const(XML_Char)* name,
                                                                    XML_Content* model);


extern(C) nothrow void
XML_SetElementDeclHandler(XML_Parser parser,
                          XML_ElementDeclHandler eldecl);

/* The Attlist declaration handler is called for *each* attribute. So
   a single Attlist declaration with multiple attributes declared will
   generate multiple calls to this handler. The "default" parameter
   may be NULL in the case of the "#IMPLIED" or "#REQUIRED"
   keyword. The "isrequired" parameter will be true and the default
   value will be NULL in the case of "#REQUIRED". If "isrequired" is
   true and default is non-NULL, then this is a "#FIXED" default.
*/
alias XML_AttlistDeclHandler = extern(C) nothrow void function(void*            userData,
                                                                    const(XML_Char)* elname,
                                                                    const(XML_Char)* attname,
                                                                    const(XML_Char)* att_type,
                                                                    const(XML_Char)* dflt,
                                                                    int              isrequired);

extern(C) nothrow void
XML_SetAttlistDeclHandler(XML_Parser parser,
                          XML_AttlistDeclHandler attdecl);

alias XML_XmlDeclHandler = extern(C) nothrow void function(void           *userData,
                                            const(XML_Char)* version_,
                                            const(XML_Char)* encoding,
                                            int             standalone);

extern(C) nothrow void
XML_SetXmlDeclHandler(XML_Parser parser,
                      XML_XmlDeclHandler xmldecl);


struct XML_Memory_Handling_Suite {
  extern(C) nothrow void* function(size_t size)            malloc_fcn;
  extern(C) nothrow void* function(void* ptr, size_t size) realloc_fcn;
  extern(C) nothrow void  function(void* ptr)              free_fcn;
}

extern(C) nothrow XML_Parser
XML_ParserCreate(const(XML_Char)* encoding);

extern(C) nothrow XML_Parser
XML_ParserCreateNS(const(XML_Char)* encoding, XML_Char namespaceSeparator);


extern(C) nothrow XML_Parser
XML_ParserCreate_MM(const(XML_Char)* encoding,
                    const(XML_Memory_Handling_Suite)* memsuite,
                    const(XML_Char)* namespaceSeparator);


extern(C) nothrow XML_Bool
XML_ParserReset(XML_Parser parser, const(XML_Char)* encoding);

alias XML_StartElementHandler = extern(C) nothrow void function(void* userData,
                                                 const(XML_Char)* name,
                                                 const(XML_Char*)* atts);

alias XML_EndElementHandler = extern(C) nothrow void function(void* userData,
                                               const(XML_Char)* name);

alias XML_CharacterDataHandler = extern(C) nothrow void function(void* userData,
                                                  const(XML_Char)* s,
                                                  int len);

alias XML_ProcessingInstructionHandler = extern(C) nothrow void function(
                                                void* userData,
                                                const(XML_Char)* target,
                                                const(XML_Char)* data);

alias XML_CommentHandler = extern(C) nothrow void function(void* userData,
                                            const(XML_Char)* data);

alias XML_StartCdataSectionHandler = extern(C) nothrow void function(void* userData);
alias XML_EndCdataSectionHandler = extern(C) nothrow void function(void* userData);

alias XML_DefaultHandler = extern(C) nothrow void function(void* userData,
                                            const(XML_Char)* s,
                                            int len);

alias XML_StartDoctypeDeclHandler = extern(C) nothrow void function(
                                            void* userData,
                                            const(XML_Char)* doctypeName,
                                            const(XML_Char)* sysid,
                                            const(XML_Char)* pubid,
                                            int has_internal_subset);

alias XML_EndDoctypeDeclHandler = extern(C) nothrow void function(void* userData);

alias XML_EntityDeclHandler = extern(C) nothrow void function(
                              void* userData,
                              const(XML_Char)* entityName,
                              int is_parameter_entity,
                              const(XML_Char)* value,
                              int value_length,
                              const(XML_Char)* base,
                              const(XML_Char)* systemId,
                              const(XML_Char)* publicId,
                              const(XML_Char)* notationName);

extern(C) nothrow void
XML_SetEntityDeclHandler(XML_Parser parser,
                         XML_EntityDeclHandler handler);

alias XML_UnparsedEntityDeclHandler = extern(C) nothrow void function(
                                    void* userData,
                                    const(XML_Char)* entityName,
                                    const(XML_Char)* base,
                                    const(XML_Char)* systemId,
                                    const(XML_Char)* publicId,
                                    const(XML_Char)* notationName);

alias XML_NotationDeclHandler = extern(C) nothrow void function(
                                    void* userData,
                                    const(XML_Char)* notationName,
                                    const(XML_Char)* base,
                                    const(XML_Char)* systemId,
                                    const(XML_Char)* publicId);

alias XML_StartNamespaceDeclHandler = extern(C) nothrow void function(
                                    void* userData,
                                    const(XML_Char)* prefix,
                                    const(XML_Char)* uri);

alias XML_EndNamespaceDeclHandler = extern(C) nothrow void function(
                                    void* userData,
                                    const(XML_Char)* prefix);

alias XML_NotStandaloneHandler = extern(C) nothrow int function(void* userData);

alias XML_ExternalEntityRefHandler = extern(C) nothrow int function(
                                    XML_Parser parser,
                                    const(XML_Char)* context,
                                    const(XML_Char)* base,
                                    const(XML_Char)* systemId,
                                    const(XML_Char)* publicId);

alias XML_SkippedEntityHandler = extern(C) nothrow void function(
                                    void* userData,
                                    const(XML_Char)* entityName,
                                    int is_parameter_entity);

struct XML_Encoding {
  int[256] map;
  void* data;
  extern(C) nothrow int function(void* data, const(char)* s) convert;
  extern(C) nothrow void function(void* data)                release;
}

alias XML_UnknownEncodingHandler = extern(C) nothrow int function(
                                    void* encodingHandlerData,
                                    const(XML_Char)* name,
                                    XML_Encoding *info);

extern(C) nothrow void
XML_SetElementHandler(XML_Parser parser,
                      XML_StartElementHandler start,
                      XML_EndElementHandler end);

extern(C) nothrow void
XML_SetStartElementHandler(XML_Parser parser,
                           XML_StartElementHandler handler);

extern(C) nothrow void
XML_SetEndElementHandler(XML_Parser parser,
                         XML_EndElementHandler handler);

extern(C) nothrow void
XML_SetCharacterDataHandler(XML_Parser parser,
                            XML_CharacterDataHandler handler);

extern(C) nothrow void
XML_SetProcessingInstructionHandler(XML_Parser parser,
                                    XML_ProcessingInstructionHandler handler);
extern(C) nothrow void
XML_SetCommentHandler(XML_Parser parser,
                      XML_CommentHandler handler);

extern(C) nothrow void
XML_SetCdataSectionHandler(XML_Parser parser,
                           XML_StartCdataSectionHandler start,
                           XML_EndCdataSectionHandler end);

extern(C) nothrow void
XML_SetStartCdataSectionHandler(XML_Parser parser,
                                XML_StartCdataSectionHandler start);

extern(C) nothrow void
XML_SetEndCdataSectionHandler(XML_Parser parser,
                              XML_EndCdataSectionHandler end);

extern(C) nothrow void
XML_SetDefaultHandler(XML_Parser parser,
                      XML_DefaultHandler handler);

extern(C) nothrow void
XML_SetDefaultHandlerExpand(XML_Parser parser,
                            XML_DefaultHandler handler);

extern(C) nothrow void
XML_SetDoctypeDeclHandler(XML_Parser parser,
                          XML_StartDoctypeDeclHandler start,
                          XML_EndDoctypeDeclHandler end);

extern(C) nothrow void
XML_SetStartDoctypeDeclHandler(XML_Parser parser,
                               XML_StartDoctypeDeclHandler start);

extern(C) nothrow void
XML_SetEndDoctypeDeclHandler(XML_Parser parser,
                             XML_EndDoctypeDeclHandler end);

extern(C) nothrow void
XML_SetUnparsedEntityDeclHandler(XML_Parser parser,
                                 XML_UnparsedEntityDeclHandler handler);

extern(C) nothrow void
XML_SetNotationDeclHandler(XML_Parser parser,
                           XML_NotationDeclHandler handler);

extern(C) nothrow void
XML_SetNamespaceDeclHandler(XML_Parser parser,
                            XML_StartNamespaceDeclHandler start,
                            XML_EndNamespaceDeclHandler end);

extern(C) nothrow void
XML_SetStartNamespaceDeclHandler(XML_Parser parser,
                                 XML_StartNamespaceDeclHandler start);

extern(C) nothrow void
XML_SetEndNamespaceDeclHandler(XML_Parser parser,
                               XML_EndNamespaceDeclHandler end);

extern(C) nothrow void
XML_SetNotStandaloneHandler(XML_Parser parser,
                            XML_NotStandaloneHandler handler);

extern(C) nothrow void
XML_SetExternalEntityRefHandler(XML_Parser parser,
                                XML_ExternalEntityRefHandler handler);

extern(C) nothrow void
XML_SetExternalEntityRefHandlerArg(XML_Parser parser,
                                   void* arg);

extern(C) nothrow void
XML_SetSkippedEntityHandler(XML_Parser parser,
                            XML_SkippedEntityHandler handler);

extern(C) nothrow void
XML_SetUnknownEncodingHandler(XML_Parser parser,
                              XML_UnknownEncodingHandler handler,
                              void* encodingHandlerData);

extern(C) nothrow void
XML_DefaultCurrent(XML_Parser parser);

extern(C) nothrow void
XML_SetReturnNSTriplet(XML_Parser parser, int do_nst);

extern(C) nothrow void
XML_SetUserData(XML_Parser parser, void* userData);

auto XML_GetUserData(XML_Parser parser) { return cast(void*) parser; }

extern(C) nothrow XML_Status
XML_SetEncoding(XML_Parser parser, const(XML_Char)* encoding);

extern(C) nothrow void
XML_UseParserAsHandlerArg(XML_Parser parser);

extern(C) nothrow XML_Error
XML_UseForeignDTD(XML_Parser parser, XML_Bool useDTD);

extern(C) nothrow XML_Status
XML_SetBase(XML_Parser parser, const(XML_Char)* base);

extern(C) nothrow const(XML_Char)* 
XML_GetBase(XML_Parser parser);

extern(C) nothrow int
XML_GetSpecifiedAttributeCount(XML_Parser parser);

extern(C) nothrow int
XML_GetIdAttributeIndex(XML_Parser parser);

struct XML_AttrInfo {
  XML_Index  nameStart;  /* Offset to beginning of the attribute name. */
  XML_Index  nameEnd;    /* Offset after the attribute name's last byte. */
  XML_Index  valueStart; /* Offset to beginning of the attribute value. */
  XML_Index  valueEnd;   /* Offset after the attribute value's last byte. */
}

extern(C) nothrow const(XML_AttrInfo)* 
XML_GetAttributeInfo(XML_Parser parser);

extern(C) nothrow XML_Status
XML_Parse(XML_Parser parser, const(char)* s, int len, int isFinal);

extern(C) nothrow void* 
XML_GetBuffer(XML_Parser parser, int len);

extern(C) nothrow XML_Status
XML_ParseBuffer(XML_Parser parser, int len, int isFinal);

extern(C) nothrow XML_Status
XML_StopParser(XML_Parser parser, XML_Bool resumable);

extern(C) nothrow XML_Status
XML_ResumeParser(XML_Parser parser);

alias XML_Parsing = uint;
enum : XML_Parsing {
  XML_INITIALIZED,
  XML_PARSING,
  XML_FINISHED,
  XML_SUSPENDED
}

struct XML_ParsingStatus {
  XML_Parsing parsing;
  XML_Bool finalBuffer;
}

extern(C) nothrow void
XML_GetParsingStatus(XML_Parser parser, XML_ParsingStatus *status);

extern(C) nothrow XML_Parser
XML_ExternalEntityParserCreate(XML_Parser parser,
                               const(XML_Char)* context,
                               const(XML_Char)* encoding);

alias XML_ParamEntityParsing = uint;
enum : XML_ParamEntityParsing {
  XML_PARAM_ENTITY_PARSING_NEVER,
  XML_PARAM_ENTITY_PARSING_UNLESS_STANDALONE,
  XML_PARAM_ENTITY_PARSING_ALWAYS
}

extern(C) nothrow int
XML_SetParamEntityParsing(XML_Parser parser,
                          XML_ParamEntityParsing parsing);

extern(C) nothrow int
XML_SetHashSalt(XML_Parser parser,
                c_ulong hash_salt);

extern(C) nothrow XML_Error
XML_GetErrorCode(XML_Parser parser);

extern(C) nothrow XML_Size XML_GetCurrentLineNumber(XML_Parser parser);
extern(C) nothrow XML_Size XML_GetCurrentColumnNumber(XML_Parser parser);
extern(C) nothrow XML_Index XML_GetCurrentByteIndex(XML_Parser parser);

extern(C) nothrow int
XML_GetCurrentByteCount(XML_Parser parser);

extern(C) nothrow const(char)* 
XML_GetInputContext(XML_Parser parser,
                    int *offset,
                    int *size);

extern(C) nothrow void
XML_FreeContentModel(XML_Parser parser, XML_Content* model);

extern(C) nothrow void* 
XML_MemMalloc(XML_Parser parser, size_t size);

extern(C) nothrow void* 
XML_MemRealloc(XML_Parser parser, void* ptr, size_t size);

extern(C) nothrow void
XML_MemFree(XML_Parser parser, void* ptr);

extern(C) nothrow void
XML_ParserFree(XML_Parser parser);

extern(C) nothrow const(XML_LChar)* 
XML_ErrorString(XML_Error code);

extern(C) nothrow const(XML_LChar)* 
XML_ExpatVersion();

struct XML_Expat_Version {
  int major;
  int minor;
  int micro;
}

extern(C) nothrow XML_Expat_Version
XML_ExpatVersionInfo();

alias XML_FeatureEnum = uint; 
enum : XML_FeatureEnum {
  XML_FEATURE_END = 0,
  XML_FEATURE_UNICODE,
  XML_FEATURE_UNICODE_WCHAR_T,
  XML_FEATURE_DTD,
  XML_FEATURE_CONTEXT_BYTES,
  XML_FEATURE_MIN_SIZE,
  XML_FEATURE_SIZEOF_XML_CHAR,
  XML_FEATURE_SIZEOF_XML_LCHAR,
  XML_FEATURE_NS,
  XML_FEATURE_LARGE_SIZE,
  XML_FEATURE_ATTR_INFO
}

struct XML_Feature {
  XML_FeatureEnum          feature;
  const(XML_LChar)*        name;
  c_long  value;
}

extern(C) nothrow const(XML_Feature)*
XML_GetFeatureList();
