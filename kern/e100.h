#ifndef JOS_KERN_E100_H
#define JOS_KERN_E100_H


#define CU_ACTIVE  0x0080
#define PACKET_SIZE 1518
#define DMA_SIZE 100
#define TRANSMIT 0x0004

extern uint8_t irqLine;
extern uint32_t portAddress;


struct tcb {
   volatile uint16_t status;
    uint16_t cmd;
    uint32_t *link;
    uint32_t TBD_ARRAY_ADDR;
    uint16_t size;
    uint8_t  THRS;
    uint8_t TBD_COUNT;
    char data[1518];     
} __attribute__((packed));

struct RFD {
   volatile uint16_t status;
    uint16_t cmd;
    uint32_t *link;
    uint32_t reserved;
    uint16_t actualCount;
    uint16_t size;
    char data[1518];     
} __attribute__((packed));




typedef struct tcb DMASendRing;
typedef struct RFD DMAReceiveRing;
extern DMASendRing sendDmaList[DMA_SIZE];
extern DMAReceiveRing receiveDmaList[DMA_SIZE];

int addEthernetDriver(struct pci_func *pcif);
void loadCUBase(void);
DMASendRing* getFreeBlock();
void incrementCurrentSend();
void copyIntoDMA(void *va,size_t len);
void ru_start(void);
void rfd_init(void);
int copyFromRFA(void *va, void *len); 
void incrementReceiveRFD();

void tcb_init();

#endif	// JOS_KERN_E100_H


