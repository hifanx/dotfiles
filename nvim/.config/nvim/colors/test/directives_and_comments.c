#include <stdio.h>   // #include: @keyword.directive
#define MAX_VALUE 10 // #define / MAX_VALUE: @keyword.directive.define, @constant.macro

int main(void) {               // int: @type, main: @function, '()'/'{}': @punctuation.bracket
    char c = 'a';              // 'a': @character
    char newline = '\n';       // '\n': @character.special and @string.escape
    int n = 42;                // 42: @number
    float f = 3.14f;           // 3.14f: @number.float
    _Bool flag = 1;            // _Bool: @type.builtin, 1: @number, used as @boolean

    int x = flag ? n : 0;      // '?:' ternary: @keyword.conditional.ternary, '?', ':' : @punctuation.special

    if (x > 0) {               // if: @keyword.conditional, '>' : @operator
        printf("x = %d\n", x); // printf: @function.builtin, string: @string, '\\n': @string.escape
    }

    for (int i = 0; i < MAX_VALUE; i++) {   // for: @keyword.repeat, ';' and ',': @punctuation.delimiter
        n += i;                             // '+=': @operator
    }

    return 0;                 // return: @keyword.return
}
