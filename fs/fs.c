#include <inc/string.h>

#include "fs.h"
#include<inc/swap.h>

// --------------------------------------------------------------
// Super block
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
	if (super->s_magic != FS_MAGIC)
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
		panic("file system is too large");

	cprintf("superblock is good\n");
}

// --------------------------------------------------------------
// Free block bitmap
// --------------------------------------------------------------
// 1 means block is free
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
}

// Search the bitmap for a free block and allocate it.  When you
// allocate a block, immediately flush the changed bitmap block
// to disk.
// 
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
              uint32_t blockNo;
         for(blockNo=0;blockNo<super->s_nblocks;blockNo++)
             {
                  if(block_is_free(blockNo)!=0)
                   {
                     bitmap[blockNo/32]&=(~(1 << (blockNo%32)));
                     void *addr = diskaddr(blockNo);
                     flush_block(bitmap+(blockNo/32));
                     return blockNo;   
                   } 

             }
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
}

// Validate the file system bitmap.
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
	assert(!block_is_free(1));
	//assert()

	cprintf("bitmap is good\n");
}

// --------------------------------------------------------------
// File system structures
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
	int swap_Handler_Block_No;
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
	
	bc_init();

	// Set "super" to point to the super block.
	super = diskaddr(1);
	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
	//cprintf("\nblock no......%d\n",alloc_block());
	cprintf("\nNo of blocks......%u\n",super->s_nblocks);
        //swap_Handler_Block_No=alloc_block();	
	//diskaddr(swap_Handler_Block_No);    
	
	//swap_handler=(struct Swap_Space *)malloc(sizeof(struct Swap_Space *));
	memset((void *)&swap_handler,0,sizeof(struct Swap_Space));
	//cprintf("goofY1\n");	
	memset(swap_handler.bitmap,0xFF,NSWAPBLK_BITSIZE*4);
	//cprintf("goofy2\n");
/*	
        if(()!=SWAPBLOCK)	
        {   

		//free_block(Swap_Handler_Block_No);
		//flush_block((void *)swap_handler);
		cprintf("\nblock no......%d\n",Swap_Handler_Block_No);
*/
		
/*	}	
        else
	{
		swap_handler = (struct Swap_Space *)diskaddr(SWAPBLOCK);
		//flush_block((void *)swap_handler);	    
	}	
*/
	cprintf("\n>>>>Beforre Sueprrr>>>>>\n");
	check_super();
	check_bitmap();
	
}

// Find the disk block number slot for the 'filebno'th block in file 'f'.
// Set '*ppdiskbno' to point to that slot.
// The slot will be one of the f->f_direct[] entries,
// or an entry in the indirect block.
// When 'alloc' is set, this function will allocate an indirect block
// if necessary.
//
// Returns:
//	0 on success (but note that *ppdiskbno might equal 0).
//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
//		alloc was 0.
//	-E_NO_DISK if there's no space on the disk for an indirect block.
//	-E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
//
// Analogy: This is like pgdir_walk for files.  
// Hint: Don't forget to clear any block you allocate.


static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
	// LAB 5: Your code here.
         
         
         if(filebno >= NDIRECT+NINDIRECT)
                  return -E_INVAL;
         if((filebno/NDIRECT)>0)
             {
                 if(f->f_indirect!=0)
               {
                  *ppdiskbno=((uint32_t *)((diskaddr(f->f_indirect))) + (filebno-NDIRECT));
                  return 0;
               }
            else if(f->f_indirect==0 && alloc!=0)
               {
                  uint32_t blockno = alloc_block();
                  if(blockno<0)
                    return -E_NO_DISK;
                  memset(diskaddr(blockno),0,BLKSIZE);
                  f->f_indirect=blockno;
                  *ppdiskbno=((uint32_t *)(diskaddr(f->f_indirect)) + (filebno-NDIRECT));
                   return 0;
               } 
            else
               return -E_NOT_FOUND;
             }
          else
             {
               *ppdiskbno=(uint32_t *)(f->f_direct + filebno);
                return 0;     
             }

	//panic("file_block_walk not implemented");
}



// Set *blk to point at the filebno'th block in file 'f'.
// Allocate the block if it doesn't yet exist.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
	// LAB 5: Your code here.
	uint32_t *ppdiskbno = 0;
        int r =file_block_walk(f,filebno,&ppdiskbno,1);
         if(r<0)
            return r;
         else
          { 
             if(*ppdiskbno==0)
               {
                 uint32_t blockno = alloc_block();
		cprintf("\n Inside file get block no---->>>>%d\n",blockno);  
                  if(blockno<0)
                    return -E_NO_DISK;
                  *ppdiskbno=blockno;
		  if(blk!=NULL)   //added for project
                  *blk = diskaddr(blockno);
                   return 0;
               }
             else
               {  if(blk!=NULL)  //added for project
                 *blk = diskaddr(*ppdiskbno);
                   return 0;
               }
          } 
        //panic("file_get_block not implemented");
}

// Try to find a file named "name" in dir.  If so, set *file to it.
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
	int r;
	uint32_t i, j, nblock;
	char *blk;
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
}

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
	if ((r = file_get_block(dir, i, &blk)) < 0)
		return r;
	f = (struct File*) blk;
	*file = &f[0];
	return 0;
}

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
	return p;
}

// Evaluate a path name, starting at the root.
// On success, set *pf to the file we found
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
	const char *p;
	char name[MAXNAMELEN];
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
		}
	}

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}

// --------------------------------------------------------------
// File operations
// --------------------------------------------------------------

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
	if (dir_alloc_file(dir, &f) < 0)
		return r;
	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
	return walk_path(path, 0, pf, 0);
}

// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
}

// Write count bytes from buf into f, starting at seek position
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
}

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
		return r;
	if (*ptr) {
		free_block(*ptr);
		*ptr = 0;
	}
	return 0;
}

// Remove any blocks currently used by file 'f',
// but not necessary for a file of size 'newsize'.
// For both the old and new sizes, figure out the number of blocks required,
// and then clear the blocks from new_nblocks to old_nblocks.
// If the new_nblocks is no more than NDIRECT, and the indirect block has
// been allocated (f->f_indirect != 0), then free the indirect block too.
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
		free_block(f->f_indirect);
		f->f_indirect = 0;
	}
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
	flush_block(f);
	return 0;
}

// Flush the contents and metadata of file f out to disk.
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
	if (f->f_indirect)
		flush_block(diskaddr(f->f_indirect));
}

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
		return r;

	file_truncate_blocks(f, 0);
	f->f_name[0] = '\0';
	f->f_size = 0;
	flush_block(f);

	return 0;
}


//Intialize swapspace

void swap_init(void)
{
struct File *f;
uint16_t i=0;
int block = 0;
uint32_t ONE=1;
uint32_t maxValue=0xFFFFFFFF;
uint32_t *indirectBlockBase;
	// creates the swap file on the boot up
	if(file_create("/swap",&f) == -E_FILE_EXISTS)
	{	/**
    		 ** If the file is already present, then open the file
                 ** and clean the bitmap and all the occupied blocks.
                 ** We do not have to allocate blocks again, as the file 
		 ** became persistent on disk. 
		 **/
		cprintf("\nFile exists\n");
		file_open("/swap",&f);
		swap_handler.swap_file = f;
		cprintf("\n>>>>>>SWAPPING>>>>>>>>%x   %x\n",swap_handler,swap_handler.bitmap);
		// clean all the previous block entries.
		for(block=0;block<(NDIRECT+NINDIRECT)/3;block++)
		{  // check which blocks have been previously occupied. Then go to the blocks and clear the entries. 
                   // 1 means free. ) 0 means occupied.
		   if(swap_handler.bitmap[(block/32)]!=maxValue && (swap_handler.bitmap[block/32] & (ONE << (block % 32)))==0)
		   {
			cprintf("\n>>>>>>%x\n",swap_handler.bitmap[(block/32)]);
			
		   	if(block<10)
		   	{                   
				memset(diskaddr(swap_handler.swap_file->f_direct[block]),0,BLKSIZE);
		   	}
		   	else
		   	{       //f->f_indirect gives the block no of the indirect block not the address.
				indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);
				// we need to get the block stored at ith position in Indirect block
				cprintf("\nBlock Panic>>>>%d\n",block);
				memset(diskaddr(*(indirectBlockBase+block-10)),0,BLKSIZE);
		   	}
                   }
		}
	}
	else
	{
		cprintf("\n-----Inside else swap_init>>>>>\n");
		swap_handler.swap_file = f;
		// else this is the first time the file is created.So,allocate the blocks to the file.
		while(i < (NDIRECT+NINDIRECT)/3) //343 bcz in total s-> n_blocks they are 1024	
	        {
			cprintf("\nInside while>>>>>%d\n",i);
		 	file_get_block(swap_handler.swap_file,i,0);  //swap_handler->swap_file previously
		 	i++;      
	        }

		// flush the state of the swap_file(i.e the blocks allocated to file) on the disk
		flush_block((void *)swap_handler.swap_file);
		flush_block(diskaddr(swap_handler.swap_file->f_indirect));
	}

	
	//clearing bitmap setting them free on startup.
	
	// write the swap struct file
	//flush_block((void *)swap_handler);
}



void reclaimExpiredBlocks()
{
	uint32_t ONE = 1;
	uint32_t *indirectBlockBase;
	uint32_t block = 0;
	uint32_t maxValue=0xFFFFFFFF;
	// check for the blocks which can be freed, bcz their env might have been destroyed..
	for(;block < NSWAPBLOCKS; block++)
	{	// check the bitmap to see which blocks have been allocated, and check whether they can be freed
		if(swap_handler.bitmap[block/32] != maxValue && ((swap_handler.bitmap[block/32]) & (ONE<<(block%32))) == 0)	
		{	//direct block
			if(block < 10)
		   	{       // system call to kernel to make check whether its vma list in  swap_store is empty.             
				if(sys_is_block_mapped((uint32_t)diskaddr(swap_handler.swap_file->f_direct[block])) <= 0)
					continue;
				else
				{	// memset the block,flush it,free the block in the bitmap.
					memset(diskaddr(swap_handler.swap_file->f_direct[block]) , 0 , BLKSIZE);
					flush_block(diskaddr(swap_handler.swap_file->f_direct[block]));
					swap_handler.bitmap[block/32] |= (ONE<<(block%32));
					break;
				}
		   	}
		   	else
		   	{       //f->f_indirect gives the block no of the indirect block not the address.
				indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);
				// we need to get the block stored at ith position in Indirect block
				//cprintf("\nBlock Panic>>>>%d\n",block);
				if(sys_is_block_mapped((uint32_t)diskaddr(*(indirectBlockBase+block-10))) <= 0)
                                        continue;
				else
				{	// memset the block,flush it,free the block in the bitmap.
					memset(diskaddr(*(indirectBlockBase+block-10)) , 0 , BLKSIZE);
					flush_block(diskaddr(*(indirectBlockBase+block-10)));
					swap_handler.bitmap[block/32] |= (ONE<<(block%32));
					break;
				}

		   	}

		}
	
	}
}




void* get_free_swap_block(void)
{
//uint32_t maxValue=0xFFFFFFFF;
uint32_t i=0;
uint32_t ONE = 1;
uint32_t *indirectBlockBase;

reclaimExpiredBlocks();	 
   // block free if 1
   for(;i<NSWAPBLOCKS;i++)
   {
	// checking which block in the swap space is free
	cprintf("\nInside block allocation\n");
	if(swap_handler.bitmap[i/32]!=0 && ((swap_handler.bitmap[i/32]) & (ONE<<(i%32)))!=0)
	{
			cprintf("\nInside block allocation>>>>>>>in\n");
		cprintf("\nadddreeeee>>>>>%x\n",swap_handler.swap_file);	
            // mark the block in the swap bitmap as occupied.
	    swap_handler.bitmap[i/32]&= (~(ONE<<(i%32)));
	    // flush the swaphandler immediately.	
            /** return the blocks from the first direct blocks, if freeth block is less than tenth, otherwise pick
	     **	the one from the indirect blocks.Remember, the blocks have already been allocated to this special file
	     ** beforehand.Now we are taking the non-occupied block from swap file's bitmap.	
	     */	
	    if(i<10)
	    	 return diskaddr(swap_handler.swap_file->f_direct[i]);
	    else
	    {
		 indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);	
	         return diskaddr(*(indirectBlockBase+i-10));
	    }
	}
   }
      // the swap space is full give error msg to swap environment
      return NULL;
}


void check_SwapBlock(void)
{ 	
int i=0;
	for(i=0;i<15;i++)
	  cprintf("\nfree block from SWAPPPPP SPACEEEEE--->>>>>>>> %d\n",((uint32_t)get_free_swap_block() - 0x10000000)/BLKSIZE);
}

// cause pgfault and get the page mapped as requested by the swapin env.
int map_page_from_disk(uint32_t blockva)
{
	uint32_t i=0;
	uint32_t pte_blockva;
	// to cause Pgfault	
	uint32_t causePgFault = *((uint32_t *)blockva);
	// check whether the page got mapped by checking PTE. 
	pte_blockva = vpt[VPN(blockva)];
	if(pte_blockva == 0 )
	   return -1;
	// got mapped then return zero.	
	return 0;
	// for test
	/*while(i < PGSIZE)
	{
		cprintf("\nByte iterator: %x\n",*(((uint8_t *)blockva)+ i));
		i++;
	}*/
}

// mark the block in swap space as free as this page has been swapped in by the swap in process.
int mark_block_free(void* blockva)
{
	uint32_t blockno = ((uint32_t)blockva - DISKMAP) / BLKSIZE;
	uint32_t *indirectBlockBase;
	uint32_t block = 0;
	uint8_t ONE = 1;
	// loop to mark the appropriate block corresponding to the blockva as free	
	for(;block < NSWAPBLOCKS/3 ;block++)
	{	
		if(block < 10)
	    	{	// if < 10, scan direct block
			if(swap_handler.swap_file->f_direct[block] == blockno)
			{	//marking the block as free in the bitmap.
			 	swap_handler.bitmap[block/32] |= (ONE<<(block%32));
				return 0; 	
			}
		}	
	    	else
	    	{	// if > 10, scan indirect blocks.
		 	indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);	
	         	if(*(indirectBlockBase + block - 10) == blockno)
		 	{	// marking the block as free in swaphandler's bitmap.
   				swap_handler.bitmap[block/32] |= (ONE<<(block%32));
				return 0;
		 	}
	    	}
	
	}
	// no such block exists return  error msg
	return -E_INVAL;
}



// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
		flush_block(diskaddr(i));
}

