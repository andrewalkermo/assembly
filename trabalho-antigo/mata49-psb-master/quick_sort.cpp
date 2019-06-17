#include <bits/stdc++.h>

using namespace std;
 
int partition(string array[], int p, int r){
    string x = array[r];
    int i = p;
 
    for(int j = p; j <= r -1; ++j){
        if(array[j] <= x){
            //i++;
            swap(array[i++], array[j]);
        }
    }
    swap(array[i], array[r]);
    return i;   
}
 
void quick_sort(string array[], int p, int r){
    if (p < r){
        int q = partition(array, p, r);
        quick_sort(array, p, q - 1);
        quick_sort(array, q + 1, r);
    }
}
 
int main() {
    ios_base::sync_with_stdio(false);
    int k;
    cin >> k;
    for (int j = 0; j < k; ++j){
        int n;
        cin >> n;
        string palavra[n];
        for (int i = 0; i < n; ++i){
            cin >> palavra[i];
        }
        quick_sort(palavra, 0, n-1);
        for (int i = 0; i < n; ++i){
            cout << palavra[i] << endl;
        }
    }
    return 0;
}
