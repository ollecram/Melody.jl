import os
import numpy as np
from scipy import stats


def calculate_chi2_memmap(filepath, total_outcomes, expected_hits, dtype=np.uint8, chunk_size=50_000_000):
    """Calcola la statistica Chi-quadro leggendo i dati da un file binario tramite np.memmap."""
    
    # 1. Mappa il file binario sul disco senza caricarlo in RAM
    # 'r' indica la modalità di sola lettura
    print(f"Mappatura del file '{filepath}' in corso...")
    observed_data = np.memmap(filepath, dtype=dtype, mode='r', shape=(total_outcomes,))

    total_chi2_stat = 0.0
    num_chunks = int(np.ceil(total_outcomes / chunk_size))

    print(f"Elaborazione di {total_outcomes} categorie in {num_chunks} blocchi tramite memmap...")

    for i in range(num_chunks):
        # Calcola gli indici di inizio e fine per il blocco corrente
        start_idx = i * chunk_size
        end_idx = min(start_idx + chunk_size, total_outcomes)

        # Estrae il blocco. NumPy legge dal disco solo questa porzione
        observed_chunk = observed_data[start_idx:end_idx]

        # Calcola (O - E)^2 / E convertendo in float64 per la precisione
        diff_sq = (observed_chunk.astype(np.float64) - expected_hits) ** 2
        chip_part = diff_sq / expected_hits

        # Accumula il risultato parziale
        total_chi2_stat += np.sum(chip_part)

        # Monitoraggio del progresso
        if (i + 1) % max(1, num_chunks // 5) == 0 or i == num_chunks - 1:
            print(f"Progresso: {i + 1}/{num_chunks} blocchi elaborati.")

    # Gradi di libertà: K - 1
    degrees_of_freedom = total_outcomes - 1

    # Calcola il p-value con la Survival Function
    print("Calcolo del p-value in corso...")
    p_value = stats.chi2.sf(total_chi2_stat, df=degrees_of_freedom)

    return total_chi2_stat, degrees_of_freedom, p_value


# --- CONFIGURAZIONE DEI PARAMETRI ---
K = 2_000_000_000       # 2 miliardi di categorie
E = 10                  # 10 hit attese in media
FILE_DATI = "conteggi_esperimento.dat"  # Sostituisci con il percorso del tuo file
TIPO_DATO = np.uint8    # Sostituisci con il tipo di dato corretto del tuo file (es. np.uint16, np.int32)

# --- NOTA: Esegui il test solo se il file esiste davvero ---
if os.path.exists(FILE_DATI):
    chi2_stat, df, p_val = calculate_chi2_memmap(
        filepath=FILE_DATI,
        total_outcomes=K,
        expected_hits=E,
        dtype=TIPO_DATO,
        chunk_size=50_000_000
    )

    print("\n--- RISULTATI DEL TEST ---")
    print(f"Statistica Chi-quadro: {chi2_stat:.4f}")
    print(f"Gradi di libertà:       {df}")
    print(f"p-value:                {p_val}")

    alpha = 0.05
    if p_val < alpha:
        print(f"\nRisultato: Rifiutiamo l'ipotesi nulla (p < {alpha}). I dati NON sono uniformi.")
    else:
        print(f"\nRisultato: Non possiamo rifiutare l'ipotesi nulla (p >= {alpha}). I dati sono uniformi.")
else:
    print(f"Errore: Il file '{FILE_DATI}' non è stato trovato. Assicurati che il percorso sia corretto.")

