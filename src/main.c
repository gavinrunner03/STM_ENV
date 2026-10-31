#include "main.h"
void SystemInit(void){
    
}

int main(void) {
    // Basic infinite loop for an embedded target
    while(1) {
        __asm__("nop"); // Do nothing safely
    }
}
