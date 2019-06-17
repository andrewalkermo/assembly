#include <iostream>

using namespace std;

int v[200];

void troca (int *a, int *b){
	int t = *a;
	*a = *b;
	*b= t;
}

int particao(int inferior_p, int superior_p){
	int pivo = v[superior_p];
	int i = inferior_p -1;
	for(int j = inferior_p; j<= superior_p -1; j++){
		if(v[j]<=pivo){
			i++;
			troca(&v[i], &v[j]);
		}
	}
	troca(&v[i+1], &v[superior_p]);
	return (i+1);
}

void quicksort(int inferior_q, int superior_q){
	if(inferior_q < superior_q){
		int divisor = particao(inferior_q,superior_q);
		quicksort(inferior_q, divisor-1);
		quicksort(divisor+1, superior_q);
	}
}

int main(){
	int n;
	cin>>n;
	for(int i=0;i<n;i++){
		int a;
		cin>>a;
		v[i]=a;
	}

	for(int i=0;i<n;i++){
		cout<<v[i]<<" ";
	}
	cout<<endl;

	quicksort(0,n-1);

	for(int i=0;i<n;i++){
		cout<<v[i]<<" ";
	}
	cout<<endl;
}

