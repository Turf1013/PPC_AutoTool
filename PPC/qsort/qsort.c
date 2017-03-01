#define LOCAL_TEST
#ifdef LOCAL_TEST
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#else
#include <zyxlib.h>
#endif

void swap(int A[], int i, int j) {
    int tmp = A[i];
    A[i] = A[j];
    A[j] = tmp;
}

int Partition(int A[], int p, int r) {
    int x = A[r];
    int i = p - 1, j;

    for (j=p; j<r; ++j) {
        if (A[j] <= x) {
            ++i;
            swap(A, i, j);
        }
    }
    swap(A, i+1, r);
    return i+1;
}

void QuickSort(int A[], int p, int r) {
    int q;

    if (p < r) {
        q = Partition(A, p, r);
        QuickSort(A, p, q-1);
        QuickSort(A, q+1, r);
    }
}

void qsort(int A[], int n) {
	QuickSort(A, 0, n-1);
}

#ifdef LOCAL_TEST
int a[20];
int main() {
	int n;
	int i, j;

	for (i = 0; i < 10; ++i) {
		n = rand() % 20 + 1;
		for (j=0; j<n; ++j)
			a[j] = rand() % 1234;
		qsort(a, n);
		for (j=0; j<n; ++j)
			printf("%d ", a[j]);
		putchar('\n');
	}

	return 0;
}
#else
int a[10] = {7, 6, 8, 1, 3, 2, 5, 9, 4, 0};
int main() {
	qsort(a, 10);

	return 0;
}
#endif 