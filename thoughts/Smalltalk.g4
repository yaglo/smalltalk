/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

grammar Smalltalk;

Digit
    :   '0'..'9'
    ;

Digits
    :   Digit+
    ;

Number
    :   (Digits 'r')? '-'? Digits ('.' Digits)? ('e' ('-')? Digits)?
    ;

Letter
    :   'A'..'Z'
    |   'a'..'z'
    ;

SpecialCharacter
    :   '+'
    |   '/'
    |   '\\'
    |   '*'
    |   '~'
    |   '<'
    |   '>'
    |   '='
    |   '@'
    |   '%'
    |   '|'
    |   '&'
    |   '?'
    |   '!'
    ;

Character
    :   Digit
    |   Letter
    |   SpecialCharacter
    |   '['
    |   ']'
    |   '{'
    |   '}'
    |   '('
    |   ')'
    |   '\u2190'    // Leftwards Arrow
    |   '\u2191'    // Upwards Arrow
    |   ','
    |   ';'
    |   '$'
    |   '!'
    |   '#'
    |   ':'
    ;

AssignmentOperator
    :   ':='
    |   '\u2190'    // Leftwards Arrow
    ;

ReturnOperator
    :   '^'
    |   '\u2191'    // Upwards Arrow
    ;

Identifier
    :   Letter (Letter|Digit)*
    ;

Symbol
    :   Identifier
    |   BinarySelector
    |   Keyword+
    ;

String: '\'' ( Character | '\'\'' | '"' )* '\'' ;

SymbolConstant: '#' Symbol ;

CharacterConstant: '$' (Character|"'"|"\"") ;

Comment: '"' (Character|'""'|'\'')* '"' ;

Array: '(' (Number|Symbol|String|CharacterConstant|Array)* ')' ;

ArrayConstant: '#' Array ;

Literal
    :   Number
    |   SymbolConstant
    |   CharacterConstant
    |   String
    |   ArrayConstant
    ;

VariableName: Identifier ;

UnarySelector: Identifier ;

BinarySelector: ('-'|SpecialCharacter|SpecialCharacter?) ;

Keyword: Identifier ':' ;

Primary
    :   VariableName
    |   Literal
    |   Block
    |   '(' Expression ')'
    ;

UnaryObjectDescription
    :   Primary
    |   UnaryExpression
    ;

BinaryObjectDescription
    :   UnaryObjectDescription
    |   BinaryExpression
    ;

UnaryExpression: UnaryObjectDescription UnarySelector ;

BinaryExpression: BinaryObjectDescription BinarySelector UnaryObjectDescription ;

KeywordExpression: BinaryObjectDescription (Keyword BinaryObjectDescription)+ ;

MessageExpression
    :   UnaryExpression
    |   BinaryExpression
    |   KeywordExpression
    ;

CascadedMessageExpression
    :   MessageExpression (';'
                           ( UnarySelector
                           | BinarySelector UnaryObjectDescription
                           | (Keyword BinaryObjectDescription)+
                           )
                          )+ ;

Expression
    :   (VariableName AssignmentOperator)*
        (Primary|MessageExpression|CascadedMessageExpression)
    ;

Statements
    :   (
        | (ReturnOperator Expression)
        | Expression
        | '.'
        )
    ;

Block
    :   '['
        ((':' VariableName)* '|')?
        Statements
       ']'
    ;

Temporaries: '|' (VariableName)* '|' ;

MessagePattern
    :   ( UnarySelector
        | BinarySelector VariableName
        | (Keyword VariableName)+
        )
    ;

Method
    :   MessagePattern
        ((Temporaries Statements)|Statements)
    ;

