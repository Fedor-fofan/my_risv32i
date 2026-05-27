int main(){
    int a = 0;
    int b = 1;

    for(int i = 0; i < 100; i++){
        int c = a + b;
        a = b;
        b = c;
    }

    return 0;
}