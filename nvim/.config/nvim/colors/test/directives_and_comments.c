// Preprocessor directives and macros
#include <stdio.h>   // #include: @keyword.directive
#define MAX_VALUE 10 // #define / MAX_VALUE: @keyword.directive.define, @constant.macro
#define SQR(x) ((x) * (x)) // SQR: @constant.macro, '(': @punctuation.bracket
#define DEBUG 1 // DEBUG: @constant.macro

#if DEBUG // #if / #endif: @keyword.directive
#    define LOG(msg) printf("[debug] %s\n", msg) // LOG: @constant.macro, string: @string
#else
#    define LOG(msg) ((void)0)
#endif

int main(void) {               // int: @type, main: @function, '()'/'{}': @punctuation.bracket
    // line comment: @comment
    char c = 'a';              // 'a': @character
    char newline = '\n';       // '\n': @character.special and @string.escape
    int n = 42;                // 42: @number
    float f = 3.14f;           // 3.14f: @number.float
    _Bool flag = 1;            // _Bool: @type.builtin, 1: @number, used as @boolean

    int x = flag ? n : 0;      // '?:' ternary: @keyword.conditional.ternary, '?', ':' : @punctuation.special

    if (x > 0) {               // if: @keyword.conditional, '>' : @operator
        printf("x = %d\n", x); // printf: @function.builtin, string: @string, '\\n': @string.escape
        LOG("x was positive"); // LOG macro call: @function.macro
    }

    for (int i = 0; i < MAX_VALUE; i++) {   // for: @keyword.repeat, ';' and ',': @punctuation.delimiter
        n += i;                             // '+=': @operator
    }

    /*
     * Block comment to show @comment documentation-style text.
     * TODO: highlight this as @comment.todo / Todo if supported.
     */

    printf("square of 3 is %d\n", SQR(3)); // SQR macro: @function.macro, Number: @number

    return 0;                 // return: @keyword.return
}
