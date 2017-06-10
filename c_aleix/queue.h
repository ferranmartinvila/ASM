#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <util/atomic.h>

#define QUEUE_MAX 50

typedef struct {
    int i;
    int count;
    uint8_t el[QUEUE_MAX];
} queue_t;

void queue_empty(queue_t *const q);

bool queue_is_empty(const queue_t *const q);

bool queue_is_full(const queue_t *const q);

void queue_enqueue(queue_t *const q, uint8_t v);

void queue_dequeue(queue_t *const q);

uint8_t queue_front(const queue_t *const q);

#endif
