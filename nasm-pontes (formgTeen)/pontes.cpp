#include <iostream>
#define MAX_PILARES 52

using namespace std;

int buscaCaminho(int mapa[][MAX_PILARES], int posInical, int posFinal, int historicoCaminho[], int value);

int main() {

    int mapaDePontes[MAX_PILARES][MAX_PILARES];
    int historicoCaminho[MAX_PILARES] = {0};

    int pilares, pontes;
    int pilarInicial, pilarFinal, quantBuracos;

    //Informa que não existe nenhuma Ponte ( -1 )
    for ( int i = 0 ; i < MAX_PILARES ; i++ )
        for ( int j = 0 ; j < MAX_PILARES ; j++ )
            mapaDePontes[i][j] = -1;

    cin >> pilares >> pontes;

    // Vou ler a posição de cada Ponte
    for ( int i = 0 ; i < pontes ; i++ ) {
        cin >> pilarInicial >> pilarFinal >> quantBuracos;

        mapaDePontes[pilarInicial][pilarFinal] = quantBuracos;
        mapaDePontes[pilarFinal][pilarInicial] = quantBuracos;
    }

    cout << buscaCaminho(mapaDePontes, 0, pilares + 1, historicoCaminho, -1) << endl;
    return 0;
}

int buscaCaminho(int mapa[][MAX_PILARES], int posInical, int posFinal, int historicoCaminho[], int value) {

    // Valor de cada tentativa;
    int valorDaTentativa;

    if ( posInical == posFinal ) {
        return 0;
    } else {
        for ( int i = 1 ; i <= posFinal ; i++ ) {

            // Eu não passei por esse Caminho e a Ponte Existe
            if ( historicoCaminho[i] == 0 && mapa[posInical][i] >= 0 ) {
                // Disse que fui? Eu vou...
                historicoCaminho[i] = 1;

                // Fui...
                valorDaTentativa = buscaCaminho(mapa, i, posFinal, historicoCaminho, value);

                // Agora voltei!
                historicoCaminho[i] = 0;

                // Checa se na Tentiva foi solução...
                if ( valorDaTentativa != -1 ) {

                    // Eu somo o buraco por onde eu passei até chegar em I
                    valorDaTentativa += mapa[posInical][i];

                    // Cehca se já achei alguma solução antes...
                    if ( value != -1 ) {
                        // Esse resulta serve...
                        if ( valorDaTentativa < value ) {
                            value = valorDaTentativa;
                        }
                    } else {
                        value = valorDaTentativa;
                    }
                }
            }

        }
    }

    return value;

}
