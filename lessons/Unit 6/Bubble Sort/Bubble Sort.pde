// int n = 10;
// int[] numbers = new int[n];
int[] numbers = {1, 2, 3};
int n = 3;

void setup() {
    printArray(numbers);
    for (int i = 0; i < n; i++) {
        numbers[i] = int(random(100));
    }
    printArray(numbers);

    for (int a = 1; a < n-1; a++) {
        for (int i = 0; i < n - a - 1; i++) {
            if (numbers[i] > numbers[i+1]) {
                int t = numbers[i];
                numbers[i] = numbers[i+1];
                numbers[i+1] = temp;
            }
            
            for (int j = 0; j < n-1; j++) {
                if (j == i) {
                    print('(' + numbers[j] + ' ');
                } else if (j == i+1) {
                    print(numbers[j] + ") ");
                } else {
                    print(numbers[j] + ' ');
                }
            }
        }
    }

    // exit();
}