import numpy as np
from scipy import stats


def calculate_chi2_streaming(total_outcomes, expected_hits, chunk_size=50_000_000):
    """Calcola la statistica Chi-quadro per blocchi (chunks) per risparmiare RAM."""
    # Inizializza la statistica Chi-quadro totale
    total_chi2_stat = 0.0

    # Calcola quanti blocchi completi e parziali servono
    num_chunks = int(np.ceil(total_outcomes / chunk_size))

    print(
        f"Elaborazione di {total_outcomes} categorie in {num_chunks} blocchi..."
    )

    for i in range(num_chunks):
        # Determina la dimensione del blocco corrente (l'ultimo potrebbe essere più piccolo)
        current_chunk_size = min(chunk_size, total_outcomes - (i * chunk_size))

        # --- SIMULAZIONE DEL TUO OUTPUT ---
        # Sostituisci questa riga con la lettura dei tuoi dati reali (es. da file o generatore)
        # Qui simuliamo le frequenze osservate (O) per il blocco corrente
        observed_chunk = np.random.poisson(lam=expected_hits, size=current_chunk_size)
        # ----------------------------------

        # Calcola (O - E)^2 / E per il blocco corrente
        # Usiamo i float64 per evitare errori di precisione o overflow con grandi somme
        diff_sq = (observed_chunk.astype(np.float64) - expected_hits) ** 2
        chip_part = diff_sq / expected_hits

        # Accumula il risultato parziale
        total_chi2_stat += np.sum(chip_part)

        # Monitoraggio del progresso (opzionale)
        if (i + 1) % max(1, num_chunks // 5) == 0 or i == num_chunks - 1:
            print(f"Progresso: {i + 1}/{num_chunks} blocchi elaborati.")

    # Gradi di libertà: K - 1
    degrees_of_freedom = total_outcomes - 1

    # Calcola il p-value usando la Survival Function (1 - CDF) di SciPy
    # La sf è numericamente stabile per p-value estremamente piccoli
    p_value = stats.chi2.sf(total_chi2_stat, df=degrees_of_freedom)

    return total_chi2_stat, degrees_of_freedom, p_value


# --- CONFIGURAZIONE DEI PARAMETRI ---
K = 2_000_000_000  # 2 miliardi di categorie
E = 10  # 10 hit attese in media per categoria

# Esegui il test statistico
chi2_stat, df, p_val = calculate_chi2_streaming(
    total_outcomes=K, expected_hits=E, chunk_size=50_000_000
)

print("\n--- RISULTATI DEL TEST ---")
print(f"Statistica Chi-quadro: {chi2_stat:.4f}")
print(f"Gradi di libertà:       {df}")
print(f"p-value:                {p_val}")

# Interpretazione del risultato
alpha = 0.05
if p_val < alpha:
    print(
        f"\nRisultato: Rifiutiamo l'ipotesi nulla (p < {alpha}). I dati NON sono uniformi."
    )
else:
    print(
        f"\nRisultato: Non possiamo rifiutare l'ipotesi nulla (p >= {alpha}). I dati sono consistenti con una distribuzione uniforme."
    )

