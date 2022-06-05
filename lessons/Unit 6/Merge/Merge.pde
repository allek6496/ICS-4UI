int r = 100;
int n = 20;

void setup() {      
   int[] a = new int[n];
   for (int i = 0; i < n; i++) {
       a[i] = int(random(-r, r));
        print(a[i], ' ');
   }

   println();

   int[] c = mergeSort( a, 0, n-1);  //should merge the arrays a and b into a single sorted array c
   
   printArray( c ); //should print out 1, 2, 4, 7, 8, 10, 11, 12, 13, 16

   exit();
}

int[] mergeSort(int[] a, int start, int end) {
    if (start == end) {
        return new int[] {a[start]};
    } else {
        int mid = (start + end) / 2;
        int first[] = mergeSort(a, start, mid);
        int second[] = mergeSort(a, mid+1, end);
        return merge(first, second);
    }
}

int[] merge( int[] a, int[] b ) {
  int[] c = new int[a.length + b.length]; //what size should c be?
  
  int i = 0;   //i is the current index for a
  int j = 0;   //j is the current index for b 
  int k = 0;   //k is the current index for c
  
  while (i < a.length && j < b.length) {
      if (a[i] < b[j]) {
          c[k] = a[i];

          i++;
          k++;
      } else {
          c[k] = b[j];

          j++;
          k++;
      }
  }

  for (int x = 0; x < c.length - k; x++) {
      int n;
      if (i == a.length) n = b[j+x];
      else n = a[i+x];

      c[k+x] = n;
  }

  return c;
}