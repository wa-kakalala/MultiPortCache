import random
import os

import struct


class data_gen_format_item:
    def __init__(self, sa:int, da:int, prior:int, flen:int, wait_cnt:int) -> None:
        
        # assert sa >= 0 and sa < 16, "error input sa"
        # assert da >= 0 and da < 16, "error input da"
        # assert prior >= 0 and prior < 8, "error input prior"
        # assert flen >= 1 and flen <= 1024, "error input len"
        # assert wait_cnt >= 0 and wait_cnt <= 1023, "error input wait time"

        # 
        self.__sa = sa
        self.__da = da
        self.__prior = prior
        self.__flen = flen
        self.__wait_cnt = wait_cnt

        # the format 32bit to be memorized in .dat file
        _ = (da<<0) + (prior<<4) + (flen<<7) + (wait_cnt<<17)
        self.__gen_data_format = format( _, '08x') #32bit 格式

        # the format 32 bit of frame/packet header
        _ = (da<<0) + (prior<<4) + (flen<<7)
        self.__header = format( _, '08x') #32bit 格式

        self.__id = 0 # default is 0



    def sa(self):
        return self.__sa
    
    def da(self):
        return self.__da
    
    def prior(self):
        return self.__prior
    
    def flen(self):
        return self.__flen
    
    def wait_cnt(self):
        return self.__wait_cnt
    
    def gen_data_format(self):
        return self.__gen_data_format
    
    def header(self):
        return self.__header

    def set_id(self, id:int):
        '''
        param: 
            id: the id of this item 
        '''
        self.__id = id

    def id(self):
        return self.__id
    



class data_gen_format:
    def __init__(self, num_sa:int, num_da:int) -> None:
        '''
        param:
            num_sa: source number
            num_da:destination number
        '''
        assert num_sa >0 and num_da >0, "error input, num_sa and num_da"
        
        self.__num_sa = num_sa
        self.__num_da = num_da

        self.__queue = {}
        for i in range(0, num_sa):
            # create empty list
            lst = [ ]
            # udpdata
            self.__queue.update( {i: lst } )

        # record whether it's set 
        self.__is_set = False
        self.__is_get_ram = False
        self.__is_get_inf = False


    def set(self, min_prior:int, max_prior:int, min_flen:int, max_flen:int, min_wtct:int, max_wtct:int):
        '''
        params:
            min_prior, max_prior:
            min_flen, max_flen:
            min_wtct, max_wtct : wait cnt
        '''
        assert min_prior<= max_prior, "error set"
        assert min_flen<= max_flen, "error set"
        assert min_wtct<= max_wtct, "error set"

        self.__min_prior = min_prior
        self.__max_prior = max_prior

        self.__min_flen  = min_flen
        self.__max_flen  = max_flen

        self.__min_wtct  = min_wtct
        self.__max_wtct  = max_wtct

        self.__is_set = True


    def gen_ram(self, ram_num:int, random_seed:int):
        '''
        params:
            num: 
        
        '''
        assert self.__is_set == True," error! i should config it first"

        self.__random_seed = random_seed
        self.__random = random
        self.__random.seed( self.__random_seed)

        for sa in range( 0, self.__num_sa):
            for n in range( ram_num ):
                da    = self.__random.randint( 0, self.__num_da-1) #[0, num_da-1]
                prior = self.__random.randint( self.__min_prior, self.__max_prior )
                flen  = self.__random.randint(self.__min_flen, self.__max_flen)
                wtct  = self.__random.randint(self.__min_wtct, self.__max_wtct)

                d_item = data_gen_format_item( sa=sa, da=da, prior=prior, flen=flen, wait_cnt=wtct)
                # set id, start id is 1, because 0 is default when unset
                d_item.set_id( n+1 ) 

                self.__queue[sa].append( d_item )

        # 
        self.__is_get_ram = True



    def print_ram(self, path:str):
        # 
        assert self.__is_set    == True, "error"
        assert self.__is_get_ram == True, "error"
        #
        assert os.path.exists(path), "save file path is error"
        # gen .dat file
        for sa in range(self.__num_sa):
            dat_file_path = os.path.join( path, "file_{:}.dat".format(sa) )
            dat_file = open( dat_file_path, 'w')

            for d_item in self.__queue[sa]:
                print(d_item.gen_data_format(), file=dat_file)

            dat_file.close()


    def gen_information(self, sended_num:list):
        '''
        generate the different number of data information( data_gen_format_item ) for different source
        params:
            num_lst: [ int, int, ...]
        '''
        # 
        assert len(sended_num) == self.__num_sa, "error! the items number of num_lst must be equal to num_sa"

        # create new empty inf queue
        self.__inf_queue = {}
        for i in range(0, self.__num_sa):
            # create empty list
            __ = { }
            # 
            for j in range(0, self.__num_da):
                __.update( {j: [] } )
            # udpdata
            self.__inf_queue.update( {i: __ } )

        for sa in range(self.__num_sa):
            for i in range( sended_num[sa] ):
                # fetch the i item in self.__queue of sa  
                d_item = self.__queue[sa][i]
                # 
                da = d_item.da() 
                self.__inf_queue[sa][da].append(d_item)

        # record
        self.__is_get_inf = True


    def print_in_information(self, path:str):
        '''
        
        '''
        # 
        assert self.__is_set    == True, "error"
        assert self.__is_get_ram == True, "error"
        assert self.__is_get_inf == True,   "error "
        #
        assert os.path.exists(path), "save file path is error"

        #open file
        txt_file_path = os.path.join( path, "gen_data_in_inf.txt" )
        txt_file = open( txt_file_path, 'w')

        # # CNT
        # cnt = 0 # 
        
        for sa in range(self.__num_sa):
            print("\n\n", file =txt_file )
            print( f"=============================SA:{sa}================================", file= txt_file)
            for da in range(self.__num_da):
                if len(self.__inf_queue[sa][da]) >0 :
                    print( f"-------------------------SA:{sa} to DA:{da}--------------------------------", file= txt_file)
                    print( "number of packets is {:}".format( len(self.__inf_queue[sa][da])), file= txt_file)
                
                for ditem in self.__inf_queue[sa][da]:
                    ditem: data_gen_format_item
                    print( "SA={},DA={},prior={},len={},wait_cnt={}, gen_format={}, header={},  id={}".format(
                        ditem.sa(),
                        ditem.da(),
                        ditem.prior(),
                        ditem.flen(),
                        ditem.wait_cnt(),
                        ditem.gen_data_format(),
                        ditem.header(),
                        ditem.id()
                    ), file= txt_file )

                # if len(self.__inf_queue[sa][da]) >0 :
                #     print( f"---------------------------------------------------------------------", file= txt_file)

            print( f"=========================================================================", file= txt_file)

        # close file
        txt_file.close()


    def print_out_information(self, path:str):
        '''
        
        '''
        # 
        assert self.__is_set    == True, "error"
        assert self.__is_get_ram == True, "error"
        assert self.__is_get_inf == True,   "error "
        #
        assert os.path.exists(path), "save file path is error"

        #open file
        txt_file_path = os.path.join( path, "gen_data_out_inf.txt" )
        txt_file = open( txt_file_path, 'w')
        
        #cnt
        cnt = 0
        sa_cnt = 0

        for da in range(self.__num_da):

            # init sa cnt for every da
            sa_cnt = 0 

            print("\n\n", file =txt_file )
            print( f"=============================DA:{da}================================", file= txt_file)
            for sa in range(self.__num_sa):
                
                if len(self.__inf_queue[sa][da]) >0 :
                    print( f"-------------------------SA:{sa} to DA:{da}--------------------------------", file= txt_file)
                    print( "number of packets is {:}".format( len(self.__inf_queue[sa][da])), file= txt_file)

                    # update sa cnt
                    sa_cnt += len(self.__inf_queue[sa][da])
                
                for ditem in self.__inf_queue[sa][da]:
                    ditem: data_gen_format_item
                    print( "SA={},DA={},prior={},len={},wait_cnt={}, gen_format={}, header={},  id={}".format(
                        ditem.sa(),
                        ditem.da(),
                        ditem.prior(),
                        ditem.flen(),
                        ditem.wait_cnt(),
                        ditem.gen_data_format(),
                        ditem.header(),
                        ditem.id()
                    ), file= txt_file )
                
                # if len(self.__inf_queue[sa][da]) >0 :
                #     print( f"---------------------------------------------------------------------", file= txt_file)

            
            cnt += sa_cnt

            print( f"==========================DA port:{da} should received {sa_cnt} packets===============================", file= txt_file)

        print( f"==========================ALL port should received {cnt} packets===============================", file= txt_file)

        # close file
        txt_file.close()
            

    def show(self):
        pass





if __name__ == "__main__":
    a = data_gen_format(16, 16)

    a.set(
        min_prior=0,    max_prior=7,
        min_flen=63,     max_flen=1023,
        min_wtct=1000,     max_wtct=1023
    )

    a.gen_ram(ram_num= 1000, random_seed=10)
    # a.print_ram(path=r"D:\Desktop\data_genformat")

    # y
    # a.gen_information([10,10,10,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 ]) # error
    a.gen_information( [20,20,20,20, 20,20,20,20, 20,20,20,20, 20,20,20,20 ])

    a.print_in_information(path=r"D:\Desktop\data_genformat")
    a.print_out_information(path=r"D:\Desktop\data_genformat")




