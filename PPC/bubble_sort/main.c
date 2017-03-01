
void handle_hw_int(void) {
	/* nothing */
}

int n = 7;
int a[15] = {21, -312, 37, -42, 75, 29, 1324};
int b[15];

void bubble_sort() {
	int i, j, tmp;

	for (i=0; i<n; ++i) b[i] = a[i];
	for (i=0; i<n; ++i) {
		for (j=i+1; j<n; ++j) {
			if (a[i] > a[j]) {
				tmp = a[i];
				a[i] = a[j];
				a[j] = tmp;
			}
		}
	}
}

int main() {
	
	bubble_sort();

	return 0;
}
