//#include <stdio.h>

#define INF 	0x3f3f3f3f
#define maxn 	5
#define false 	0
#define true 	1

unsigned int M[maxn][maxn] = {
	{0,1,2,3,4},
	{8,0,7,6,5},
	{9,10,0,11,12},
	{16,15,14,0,13},
	{17,18,19,20,0}
};
unsigned int dis[maxn];
unsigned char visit[maxn];

unsigned int output();
void dijkstra();

void dijkstra() {
	unsigned int i, j, k;
	unsigned int v, mn;
	unsigned int s = 0;
	unsigned int total = 0;

	for (i=0; i<maxn; ++i) {
		dis[i] = M[s][i];
		visit[i] = false;
	}

	dis[s] = 0;
	visit[s] = true;

	for (i=1; i<maxn; ++i) {
		mn = INF;
		v = maxn;
		for (j=0; j<maxn; ++j) {
			if (!visit[j] && dis[j]<mn) {
				v = j;
				mn = dis[j];
			}
		}

		if (v == maxn)
			break;
		
		visit[v] = true;
		for (j=0; j<maxn; ++j) {
			if (!visit[j] && mn+M[v][j]<dis[j]) {
				dis[j] = M[v][j];
			}
		}
	}

	total += output();
}

unsigned int output() {
	unsigned int sum = 0, i;
	for (i=0; i<maxn; ++i)
		sum += dis[i];
	return sum;
}


int main() {
	unsigned int total = 0;

	dijkstra();
	total = output();
	return 0;
}
