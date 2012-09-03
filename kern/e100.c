// LAB 6: Your driver code here


#include <inc/lib.h>
#include <kern/pci.h>
#include <inc/x86.h>
#include <inc/memlayout.h>
#include <kern/e100.h>

#define CHECK_CMPL 0x8000
#define OK 0x2000
#define EL_BIT 0x8000
#define S_BIT 0x4000
#define CU_SUSPEND 0x0040
#define CU_START 0x10
#define CU_LOAD_BASE 0x60
#define RU_START 0x0001
#define NO_PACKET -1
#define RFA_FULL  -1
#define EL_BIT 0x8000

uint8_t irqLine;
uint32_t portAddress;
DMASendRing sendDmaList[DMA_SIZE];
DMAReceiveRing receiveDmaList[DMA_SIZE];
DMASendRing *current=sendDmaList;
DMASendRing *sendHeader=sendDmaList;
DMAReceiveRing *currentRFD=receiveDmaList;

 void
delay(void)
{
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84); 
}


void tcb_init(void)
{
   memset(sendDmaList,0,DMA_SIZE*sizeof(DMASendRing));
   int i=0;
   for(;i<DMA_SIZE;i++)
    {
       sendDmaList[i].THRS=0xe0;
       sendDmaList[i].TBD_ARRAY_ADDR= 0xFFFFFFFF;
        if(i<DMA_SIZE-1) 
         sendDmaList[i].link=(uint32_t *)(((uint32_t)(sendDmaList+i+1))-KERNBASE);
        else
         sendDmaList[i].link=(uint32_t *)(((uint32_t)sendDmaList)-KERNBASE);
      //cprintf("\nKADDR%x\n",((uint32_t)sendDmaList[i].link)+KERNBASE);
    }

}


void rfd_init(void)
{
   memset(receiveDmaList,0,DMA_SIZE*sizeof(DMAReceiveRing));
   int i=0;
   for(;i<DMA_SIZE;i++)
    {
       receiveDmaList[i].reserved= 0xFFFFFFFF;
       receiveDmaList[i].size=1518; 
       if(i<DMA_SIZE-1)
         { 
         receiveDmaList[i].link=(uint32_t *)(((uint32_t)(receiveDmaList+i+1))-KERNBASE);
         //setting EL bit
         }
          else
          {
            receiveDmaList[i].link=(uint32_t *)(((uint32_t)receiveDmaList)-KERNBASE);
            receiveDmaList[i].cmd=EL_BIT; 
          }
        // cprintf("\nKADDR%x\n",((uint32_t)receiveDmaList[i].link)+KERNBASE);
    }

}





int addEthernetDriver(struct pci_func *pcif)
{
pci_func_enable(pcif);
irqLine = pcif->irq_line;
portAddress=pcif->reg_base[1];
uint32_t temp = inl(portAddress + 0x8);
outl(portAddress+0x8,0x0); 
delay();
tcb_init();
rfd_init();
ru_start();
return 0;
}


void ru_start(void)
{
cprintf("\n-->here RU start\n");
outl(portAddress+0x4,((uint32_t)(receiveDmaList)-KERNBASE));
outb(portAddress+0x3, 0xFF);
outb(portAddress+0x2,0x01);
}


int copyFromRFA(void *va,void *len)
{
//int i=0;
//cprintf("\n-->here copyfrom RFA start\n");
//for(;i<DMA_SIZE;i++)
//{
  //checkForFreeRFA();
 if(((currentRFD->status & CHECK_CMPL)== CHECK_CMPL)  && ((currentRFD->status & OK)== OK)  && (currentRFD->actualCount & 0xc000) )
     {
       //memmove(va,(receiveDmaList[i].actualCount & 0x3FFF));
        cprintf("\nstatuse=------%x\n",currentRFD->status);
        cprintf("\nEOF=------%x\n",(currentRFD->actualCount& 0xc000));
        memmove(va,currentRFD->data,(currentRFD->actualCount & 0x3FFF));
        uint32_t *locallen=(uint32_t *)len;
        //cprintf("len--->%x",len);
       *locallen=(currentRFD->actualCount & 0x3FFF); 
        ///stting the pkt len
        //va->pkt.jp_len=(receiveDmaList[i].actualCount & 0x3FFF);
  //     cprintf("\n-->Actual Count--->\n%d",(currentRFD->actualCount & 0x3FFF));      
       memset(currentRFD->data,0,1518);
       currentRFD->actualCount=0;
       currentRFD->cmd=0;
       currentRFD->status=0;
       
      
       if((uint32_t)currentRFD>(uint32_t)receiveDmaList)
        { 
    //         cprintf("\ncurrentRFD--->%x   receiveDmaList%x\n",currentRFD,receiveDmaList);
      //       cprintf("\nAbove if--->%x   EL-bit%x\n",((currentRFD-1)->cmd & EL_BIT),EL_BIT);
        //     cprintf("\nLastttt--->%x   receiveDmaList%x\n",(receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) ,EL_BIT); 
           if(((currentRFD-1)->cmd & EL_BIT) == EL_BIT)
             {
                cprintf("\nChanging EL bit>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
               currentRFD->cmd = EL_BIT;
               (currentRFD-1)->cmd&=0x7FFF; 
             }
        }
      else
        {
     //cprintf("\nLasttt--->%x   receiveDmaList%x\n",(receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) ,EL_BIT); 
          if((receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) == EL_BIT)
              {  

                cprintf("\nChanging EL bit below\n");
                receiveDmaList[DMA_SIZE-1].cmd &=0x7FFF ;
                currentRFD->cmd=EL_BIT;
              } 
        }
       incrementReceiveRFD();
       return 0; 
     }
 else
  return NO_PACKET; 
 
}


void loadCUBase(void)
{
  uint16_t status_word=inw(portAddress);
       if(CU_ACTIVE & status_word)
          return;
   outl(portAddress+0x4,((uint32_t)(sendDmaList)-KERNBASE));  
   outb(portAddress+0x3, 0xFF);
  //start
  outb(portAddress+0x2,CU_START);
  uint8_t status_word2=inb(portAddress);
 // cprintf("status word>>>> %d",(status_word2 & 0xC0));
 
}
 
// resume it when the CU is in suspended mode
// restart it when in idle.
void copyIntoDMA(void *va,size_t len)
{

DMASendRing *freeblock = getFreeBlock();
if(freeblock!=NULL)
  {
       //cprintf("%d",sizeof(DMASendRing)); 
       //cprintf("\n%x  %x",freeblock,sendDmaList);
        memmove(freeblock->data,va,len);
	//set the S bit here
       // cprintf("Current-> %x   FreeBlock--> %x",current,freeblock);
	int i=0;
        while(freeblock->data[i]!='\0')
        {
        //cprintf("%c",freeblock->data[i]);
         i++;
        }
        freeblock->cmd = freeblock->cmd|S_BIT;	                 
	freeblock->size = len; 	
        freeblock->cmd|=TRANSMIT;
        incrementCurrentSend();
  }
else
  {
   cprintf("\nDMA Ring Full\n");
    return;
  }
// setting the previous S bit to zero.Assuming there will be no error.
   /*DMASendRing *prev=NULL; 
   getPreviousSend(&prev); 
   prev->cmd=0;
*/
   uint16_t deviceStatus=inb(portAddress);
   //cprintf("Device Status%x\n",(deviceStatus & 0x00F0));
  if( 0x00 == (deviceStatus & 0xC0) )
                {
      //             cprintf("\nHere starting\n");
                    loadCUBase();
                }


   else if((deviceStatus & 0xC0) ==CU_SUSPEND)
       {
     //      cprintf("\nInside sending\n");
            //uint16_t commandWord = inw(portAddress+0x2);
            //RESUME
            //commandWord&=0xFF2F;
    //        cprintf("\nHere Suspend\n");
            outw(portAddress+0x2,0x20);
       }
   
  //else if(deviceStatus & CU_ACTIVE)
}


DMASendRing *getFreeBlock()
{
int i=0;
 for(;i<DMA_SIZE;i++)
  {
  
  // cprintf("\nCurrent---->%x",current);
 
   if(current->size!=0)
      {
            //cprintf("\nInside %d",current->size);
            //cprintf("\nRead Status Word--->%x",current->status); 
            if(((current->status & CHECK_CMPL)==CHECK_CMPL) && ((current->status & OK)==OK))//(1  
              {
                //cprintf("\nInside OK bit");
                 memset(current->data,0,1518);
                 current->status=0;
                 current->cmd=0;
                 //current->THRS=0xe0;
                 current->size = 0;
                 return current;
              }
          else if((current->status & CHECK_CMPL) ==CHECK_CMPL && (current->status & OK)!=OK)
                { 
                  cprintf("\nInside error bit\n");
                  current->status&=(~CHECK_CMPL);
                }
   
      }
   else 
    return current;
  incrementCurrentSend();
  }
  return NULL;
}

void incrementCurrentSend()
{
  if(current==&sendDmaList[DMA_SIZE-1])
     current=sendDmaList;
   else
    current++;
}

void incrementReceiveRFD()
{
  if(currentRFD==&receiveDmaList[DMA_SIZE-1])
     currentRFD=receiveDmaList;
   else
    currentRFD++;
}


