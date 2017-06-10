#include "queue.h"

void queue_empty(queue_t *const q)
/* Inicialitza la cua q a l’estat buit. */
{
    q->i = 0;
    q->count = 0;
}

bool queue_is_empty(const queue_t *const q)
/* Retorna true ssi q és buida. */
{
    return (q->count == 0);
}

bool queue_is_full(const queue_t *const q)
/* Retorna true ssi q és plena. */
{
    return (q->count == QUEUE_MAX);
}

void queue_enqueue(queue_t *const q, uint8_t v)
/* Encua l’element v a la cua q. Si la cua és plena no encua res. */
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
        {
            if (!queue_is_full(q)) {
            q->el[(q->i + q->count) % QUEUE_MAX] = v;
            ++q->count;
        }
    }
}

void queue_dequeue(queue_t *const q)
/* Desencua l’element del davant de la cua q. Si la cua és buida no
fa res. */
{
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        if (!queue_is_empty(q)) {
            q->i = (q->i + 1) % QUEUE_MAX;
            --q->count;
        }
    }
}

uint8_t queue_front(const queue_t *const q)
/* Retorna l’element del davant de la cua q. Si la cua és buida
retorna un valor arbitrari. */
{
    return q->el[q->i];
}
