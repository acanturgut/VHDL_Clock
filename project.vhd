
-- INSTITUTION: KOÇ UNIVERSITY
-- CLASS: ELEC 204 FALL 2015
-- STUDENTS: DORUK RESMÝ -- AHMET CAN TURGUT 
-- INSTRUCTOR: ENGÝN ERZÝN
-- Create Date:    20:20:30 12/22/2015 
-- Design Name:    DIGITAL CLOCK
-- Module Name:    Project - Behavioral 
-- Project Name:   DIGITAL CLOCK with ALARM and CHRONOMETER
-- Target Devices: SPARTAN 3e
-- Tool versions:  UNKNOWN   
-- Additional Comments: CHECK SETUP.PDF File.
--
--
-- NORMAL MODE      -- 01 -- SWITCH0-1
-- SET MODE         -- 00 -- SWITCH0-1
-- ALARM MODE       -- 10 -- SWITCH0-1
-- CHRONOMETER MODE -- 11 -- SWITCH0-1

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Project is
   Port (  RCCLK : in STD_LOGIC;
			  CLK    : in STD_LOGIC;
 			  SWITCH  : in  STD_LOGIC_VECTOR(1 downto 0);
			  SWITCH_YEAR: in STD_LOGIC;
           BUTTON1 : in  STD_LOGIC;
           BUTTON2 : in  STD_LOGIC;
           BUTTON3 : in  STD_LOGIC;
           BUTTON4 : in  STD_LOGIC;
			  LED     : out STD_LOGIC_VECTOR(7 downto 0);
			  ANODES_Out : out STD_LOGIC_VECTOR(3 downto 0);
           SEVEN_SEG_Out : out STD_LOGIC_VECTOR(6 downto 0);
           Dot_Point: out STD_LOGIC
			  );
end Project;

architecture Behavioral of Project is

Signal S0, S1, M0, M1, H0, H1, D0, D1, MM0, MM1, Y0 ,Y1: STD_LOGIC_VECTOR(3 downto 0);
Signal Set_M0, Set_M1, Set_H0, Set_H1, Set_D0, Set_D1, Set_MM0, Set_MM1, Set_Y0 ,Set_Y1: STD_LOGIC_VECTOR(3 downto 0);        
Signal Alm_Set_M0, Alm_Set_M1, Alm_Set_H0, Alm_Set_H1: STD_LOGIC_VECTOR(3 downto 0);
Signal CS0, CS1, CM0, CM1: STD_LOGIC_VECTOR(3 downto 0);
Signal SEVEN_SEG_in: STD_LOGIC_VECTOR(3 downto 0);
Signal Anodes: STD_LOGIC_VECTOR(3 downto 0):="1110";
Signal FF : STD_LOGIC_VECTOR(7 downto 0):="00000000"; 

begin 
  process (RCCLK,SWITCH,CLK)
  variable Counter : integer range 0 to 4:=0;
  variable SET_Counter : integer range 0 to 4:=0;
  variable ALM_SET_Counter: integer range 0 to 1:=0;
  variable OneKHZ: integer range 0 to 25000:=0; 
  variable OneHZ : integer range 0 to 43000000:=0;
  variable SET_HZ: integer range 0 to 4000000:=0;
  variable cnt :   integer := -1;
  
begin

if(rising_edge(CLK)) then
    OneKHZ:= OneKHZ+1;
    OneHZ := OneHZ +1;
	 SET_HZ := SET_HZ +1;
	   
		--Normal MOD Counter
	 
	   if(OneHZ=0) then
		
		  S0 <= S0 + 1;
		   if S0="1001" then
	        S0<="0000";
	        S1 <= S1 +1;
	      end if;
		   
		   if (S1="0101") AND (S0="1001") then
		      S1 <="0000";
		      M0 <= M0 + 1 ;
		   end if;
      
		   if M0="1001" then
		     M0<="0000";
	        M1 <= M1 +1;
		   end if;
		
		   if (M1="0101") AND (M0="1001") then
		      M1 <="0000";
		      H0 <= H0 + 1 ;
		   end if;
		  
		   if H1="0010" then
	           if H0="0011" then
			        H0 <="0000";
	              H1 <="0000" ;
			     else	 
				     H0<=H0+1;
				  end if;
		   end if;
	    
		   if H0="1001" then
			   H0 <="0000";
		      H1 <= H1 + 1;    
		   end if;
		   if (H0 = "0011") AND (H1 = "0010") then
				 H0 <= "0000";
				 H1 <= "0000";			  
				 D0 <= D0 + 1;
			end if;	  
			
			if D0 = "1001" then 
				D0 <= "0000";
				D1 <= D1 + 1;
			end if;

			if (D1 = "0011") AND (D0 = "0001") then
			     D0 <= "0000";
				  D1 <= "0000";
				  MM0 <= MM0 +1;
			end if;
			
			if (MM0 = "1001") then
				 MM0<="0000";
				 MM1 <= MM1+1;
			end if;
			
         if (MM0= "0010") AND (MM1="0001")AND (D0="0001") AND (D1="0011")  then
				 MM0<="0000";
				 MM1<= "0000";
				 Y0 <= Y0+1 ;
		   end if;
			
         if Y0="1001" then
				Y0 <= "0000";
				Y1<= Y1+1;
			end if;
			 
	      if Y1="1001" then
				 Y1 <= "0000";
				 Y0 <= "0000";
			end if;
			 
	      if (Alm_Set_M0=M0) AND (Alm_Set_M1=M1) AND (Alm_Set_H0=H0) AND (Alm_Set_H1=H1) then
                 --.-- State transitions      
					  FF(1) <= (FF(0) OR FF(2));
                 FF(2) <= (FF(1) Or FF(3));
					  FF(3) <= (FF(2) OR FF(4));
					  FF(4) <= (FF(3) OR FF(5));
					  FF(5) <= (FF(4) OR FF(6));
					  FF(6) <= (FF(5) OR FF(7));
                 FF(7) <= (FF(6) OR (NOT FF(0)));
                 FF(0) <= ((NOT FF(7)) OR FF(1));
					  
             if(FF="11111111")then
             FF<="00000000"	;			 
		       end if;
				 
		    else
		       FF<="00000000"	;	
		    end if;

	    end if;--Normal MOD Counter End

             -- CHRONOMETER COUNTER --
		
	          if cnt = -2 then 
	           	if(OneHZ=0) then
		            CS0 <= CS0 + 1;
		 
						if CS0="1001" then
	                  CS0<="0000";
							CS1 <= CS1 +1;
						end if;
						
						if (CS1="0101") AND (CS0="1001") then
							 CS1 <="0000";
							 CM0 <= CM0 + 1 ;
						end if;
      
						if CM0="1001" then
							CM0<="0000";
							CM1 <= CM1 +1;
						end if;
		
						if (M1="0101"AND M0="1001") then
							 M1 <="0000";
						end if;
				 end if;
end if;	
		
-- CHRONOMETER MODE -- END --
	
if SWITCH="01"then --SET MOD---
	    
		if(OneKHZ=0)then
		   Counter :=Counter+1;
			   if (Counter=0) then
					
					 if(SET_Counter=0)then--When setting Hour
					 
			          SEVEN_SEG_in<= Set_H0; 
			          Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			          Dot_Point <= '1';
					 
					 elsif(SET_Counter=1)then--When Setting Minute
					 
					    SEVEN_SEG_in<= "1010"; 
			          Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			          Dot_Point <= '1';
					 
					 elsif(SET_Counter=2)OR (SET_Counter=3)then--When Setting Day And Month
					 
					    SEVEN_SEG_in<= Set_D0; 
			          Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			          Dot_Point <= '1';
					 
					 elsif(SET_Counter=4)then--When Setting Year
					    SEVEN_SEG_in<= Set_Y0; 
			          Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			          Dot_Point <= '1';
					 
					 end if;
			          
		         elsif (Counter=1) then
					
					 if(SET_Counter=0)then--When setting Hour
					 
						  SEVEN_SEG_in<= Set_H1;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
		              Dot_Point <= '1';
					 
					 elsif(SET_Counter=1)then--When Setting Minute
					     SEVEN_SEG_in<= "1010";
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
		              Dot_Point <= '1';
					 
					 elsif(SET_Counter=2)OR (SET_Counter=3)then--When Setting Day And Month
					     SEVEN_SEG_in<= Set_D1;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
		              Dot_Point <= '1';
					 
					 elsif(SET_Counter=4)then--When Setting Year
					     SEVEN_SEG_in<= Set_Y1;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
		              Dot_Point <= '1';
					end if;	
					
		         elsif (Counter=2) then
					 if(SET_Counter=0)then--When setting Hour
                    SEVEN_SEG_in<= "1100";
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '0';
					 elsif(SET_Counter=1)then--When Setting Minute
					 SEVEN_SEG_in<= Set_M0;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '0';
					 elsif(SET_Counter=2)OR (SET_Counter=3)then--When Setting Day And Month
					 SEVEN_SEG_in<= Set_MM0;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '0';
					 elsif(SET_Counter=4)then--When Setting Year
					 SEVEN_SEG_in<= "1101";
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '0'; 
					 end if;  
		         elsif (Counter=3) then
					
					 if(SET_Counter=0)then--When setting Hour
					     SEVEN_SEG_in <="1100" ;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '1';
					 elsif(SET_Counter=1)then--When Setting Minute
					     SEVEN_SEG_in <= Set_M1;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '1';
					 elsif(SET_Counter=2)OR (SET_Counter=3)then--When Setting Day And Month
					     SEVEN_SEG_in <= Set_MM1;
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '1';
						  
					 elsif(SET_Counter=4)then--When Setting Year
					     SEVEN_SEG_in <= "1101";
			           Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			           Dot_Point <= '1';
					 
					 end if;
			           
						  
				   end if;

				            				 
         end if;
    if(SET_HZ=0) then
		  if  BUTTON1='1' then--Changing the Setting Values--
		       SET_Counter:=SET_Counter+1;
        end if; 
		  if BUTTON3='1' then -- Increment the Set Values--
		      if SET_Counter=0 then--Hour
		              Set_H0<=Set_H0+1;
						  if (Set_H1="0010") AND (Set_H0="0011")   then
	                        Set_H0 <="0000";
	                        Set_H1 <="0000" ;
	                 else
		                   if Set_H0="1001" then
			                   Set_H0 <="0000";
		                      Set_H1 <= Set_H1 + 1;    
		                   end if;
						  end if;
				 elsif SET_Counter=1 then--Minute--
            		  Set_M0<= Set_M0 +1;
						  
						  if Set_M0="1001" then
		                 Set_M0<="0000";
	                    Set_M1 <= Set_M1 +1;
							  if (Set_M1="0101") AND (Set_M0="1001") then
		                   Set_M1 <="0000";  
								 Set_M0 <="0000";		
		              end if;
							  
							  
		              end if;
				elsif SET_Counter=2 then--Day--
				      Set_D0<=Set_D0+1;
                  if (Set_D1="0011") AND (Set_D0="0001")  then
						    Set_D0<="0000";
							 Set_D1<="0000";
						else 							
			             if Set_D0="1001" then
							     Set_D0<="0000";
								  Set_D1<=Set_D1 + 1;
							 end if;
                  end if; 			
			   elsif SET_Counter=3 then--Month--
                  Set_MM0<=Set_MM0+1;
                  if(Set_MM1="0001") AND (Set_MM0="0010")then
                     Set_MM0<="0000";
                     Set_MM1<="0000";						
                  else
					      if Set_MM0="1001" then
						      Set_MM0<="0000";
							   Set_MM1<=Set_MM1 +1;
							end if;
                  end if;
            elsif SET_Counter=4 then--Year--
                  Set_Y0<=Set_Y0 +1;
                  if Set_Y0="1001" then
                     Set_Y0<="0000";
                     Set_Y1<=Set_Y1+1;
                  end if;
                  if Set_Y1="1001" then
                     Set_Y1<="0000";
                  end if;	
            end if;
			end if;
		 if BUTTON4='1' then 
		 --Decrement the Set Values--
		    if SET_Counter=0 then--Hour
                    Set_H0<=Set_H0-1;		            
						if (Set_H1="0000") AND (Set_H0="0000")   then
	                        Set_H0 <="0011";
	                        Set_H1 <="0010" ;
	               else
		                   if Set_H0="0000" then
			                   Set_H0 <="1001";
		                      Set_H1 <= Set_H1 - 1;    
		                      end if;
						end if;   
			 elsif SET_Counter=1 then--Minute--
            		    Set_M0<= Set_M0 -1;
						  if Set_M0="0000" then
		                 Set_M0<="1001";
	                    Set_M1 <= Set_M1 -1;
		              end if;
		
		              if (Set_M1="0000")AND (Set_M0="0000") then
		                   Set_M1 <="0101";    
		              end if;   
			 elsif SET_Counter=3 then--Day--
				    Set_D0<=Set_D0-1;	
                  if (Set_D1="0000") AND (Set_D0="000")  then
						     Set_D0<="0001";
							  Set_D1<="0011";				  
						else 							
			             if Set_D0="0000" then
							     Set_D0<="1001";
								  Set_D1<=Set_D1 - 1;
							 end if;
                   end if; 					 
			 elsif SET_Counter=4 then--Month--
                  Set_MM0<=Set_MM0-1;
                  if(Set_MM1="0000") AND (Set_MM0="0000")then
                     Set_MM0<="0010";
                     Set_MM1<="0001";						
                  else
					      if Set_MM0="0000" then
						      Set_MM0<="1001";
							   Set_MM1<=Set_MM1 -1;
							end if;
                   end if;	 
          elsif SET_Counter=5 then--Year--
                  Set_Y0<=Set_Y0 -1;
                  if Set_Y0="0000" then
                     Set_Y0<="1001";
                     Set_Y1<=Set_Y1-1;
                  end if;
                  if Set_Y1="0000" then
                     Set_Y1<="1001";
                  end if; 						
          end if;
		end if;
	 end if;
	 
		if(BUTTON2='1')then
		
		--Finish Setting---
		--Set Values goes into Normal Values

	       S0<="0000";
			 S1<="0000";
			 M0<=Set_M0;
	       M1<=Set_M1;
	       H0<=Set_H0;
	       H1<=Set_H1;
	       D0<=Set_D0;
	       D1<=Set_D1;
	       MM0<=Set_MM0;
	       MM1<=Set_MM1;
	       Y0<=Set_Y0;
	       Y1<=Set_Y1;
			 
		end if;
	
	elsif SWITCH="00" then --NORMAL MOD--
		   
			if(OneKHZ=0)then
              Counter :=Counter+1;
              if (Counter=0) then 
                    if BUTTON1 = '1' then
				          SEVEN_SEG_in<=Y0;
				         else
				          SEVEN_SEG_in<= D0;
				         end if;
		               if SWITCH_YEAR = '1' then 
		               else 
		                     if BUTTON1 = '1' then
				                  SEVEN_SEG_in<=H0;
				               else
				                   SEVEN_SEG_in<= S0;
				               end if;
				         end if;	
				    Anodes <= (Anodes(2 downto 0) & Anodes(3));	
				    Dot_Point <= '1';
			      elsif (Counter=1) then
				         if SWITCH_YEAR = '1' then 
				             if BUTTON1 = '1' then
				                SEVEN_SEG_in<=Y1;
				             else
				                SEVEN_SEG_in<= D1;
				             end if;
                     else 
					          if BUTTON1 = '1' then
				                SEVEN_SEG_in<=H1;
				             else
				                SEVEN_SEG_in<= S1;
				             end if;
				         end if;
				    Anodes <= (Anodes(2 downto 0) & Anodes(3));	
		          Dot_Point <= '1';
			     elsif (Counter=2) then
			           if SWITCH_YEAR = '1' then 
				            if BUTTON1 = '1' then
                           SEVEN_SEG_in<= "1101" ;
				            else
				               SEVEN_SEG_in<= MM0;
				            end if;
			           else 		
		                   if BUTTON1 = '1' then
				                SEVEN_SEG_in <= "1100";
				             else
				                SEVEN_SEG_in<= M0;
				             end if;
				         end if;	
				     Anodes <= (Anodes(2 downto 0) & Anodes(3));	
				     Dot_Point <= '0';
			     elsif (Counter=3) then
			            if SWITCH_YEAR = '1' then 
				            if BUTTON1 = '1' then
				               SEVEN_SEG_in<= "1101" ;
				            else
				               SEVEN_SEG_in<= MM1;
				            end if;
			            else 
			               if BUTTON1 = '1' then
				               SEVEN_SEG_in <= "1100";
				            else
                           SEVEN_SEG_in <= M1;
				            end if;
				         end if;
				    Anodes <= (Anodes(2 downto 0) & Anodes(3));	
				    Dot_Point <= '1';
			     end if;
		 end if;
	elsif SWITCH="10" then	-- ALARM MOD--
		FF<="00000001";
		if(OneKHZ=0)then--Alarm Display--
		--Rotating Anodes--
		       Counter :=Counter + 1;
					if (Counter=0) then
			          SEVEN_SEG_in<= Alm_Set_M0; 
			          Anodes <= (Anodes(2 downto 0) & Anodes(3));
			          Dot_Point <= '1';
		         elsif (Counter=1) then
			           SEVEN_SEG_in<= Alm_Set_M1;
			          	Anodes <= (Anodes(2 downto 0) & Anodes(3));
		              Dot_Point <= '1';
		         elsif (Counter=2) then
			           SEVEN_SEG_in<= Alm_Set_H0;
			           	Anodes <= (Anodes(2 downto 0) & Anodes(3));
			           Dot_Point <= '0';
		         elsif (Counter=3) then
			           SEVEN_SEG_in <=Alm_Set_H1 ;
			           	Anodes <= (Anodes(2 downto 0) & Anodes(3));
			           Dot_Point <= '1';
		         end if; 
		end if;--Alarm Display--Rotating Anodes--End--	  
		if(SET_HZ=0)then --Alarm Set Counter Loop
		    if  BUTTON1='1' then--Changing the Setting Values--
		        ALM_SET_Counter:= ALM_SET_Counter + 1;
          end if; 		    
			 if BUTTON3='1' then -- Increment the Alarm Set Values--
		      if  ALM_SET_Counter=0 then--Hour
		              Alm_Set_H0<=Alm_Set_H0+1;
						  if (Alm_Set_H1="0010") AND (Alm_Set_H0="0011")   then
	                        Alm_Set_H0 <="0000";
	                        Alm_Set_H1 <="0000" ;
	                 else
		                   if Alm_Set_H0="1001" then
			                   Alm_Set_H0 <="0000";
		                      Alm_Set_H1 <= Alm_Set_H1 + 1;    
		                      end if;
						  end if;
				 elsif  ALM_SET_Counter=1 then--Minute--
            		  Alm_Set_M0<= Alm_Set_M0 +1;
						  
						  if (Alm_Set_M1="0101")AND (Alm_Set_M0="1001") then
		                   Alm_Set_M1 <="0000"; 
                         Alm_Set_M0 <="0000";								 
		             else
						 if Alm_Set_M0="1001" then
		                 Alm_Set_M0<="0000";
	                    Alm_Set_M1 <= Set_M1 +1;
		             end if;
						 end if;
	         end if;
			 end if;
		    if BUTTON4='1' then --Decrement the Alarm Set Values--
		       if  ALM_SET_Counter=0 then--Hour
                    Alm_Set_H0<=Alm_Set_H0-1;		            
						if (Alm_Set_H1="0000") AND (Alm_Set_H0="0000")   then
	                        Alm_Set_H0 <="0011";
	                        Alm_Set_H1 <="0010" ;
	               else
		                   if Alm_Set_H0="0000" then
			                   Alm_Set_H0 <="1001";
		                      Alm_Set_H1 <= Set_H1 - 1;    
		                      end if;
					   end if;			   
				 elsif  ALM_SET_Counter=1 then--Minute--
            		    Alm_Set_M0<= Alm_Set_M0 -1;
		               if (Alm_Set_M1="0000")AND (Alm_Set_M0="0000") then
		                   Alm_Set_M1 <="0101";
								 Alm_Set_M0 <="1001";		
		              else
						  if Alm_Set_M0="0000" then
		                 Alm_Set_M0<="1001";
	                    Alm_Set_M1 <= Set_M1 -1;
		              end if;
					end if;		
	          end if;
			 end if;
		end if;--Alarm Set Counter Loop
	elsif SWITCH="11" then 
	
	--CHRONOMETER MODE--
	
	if BUTTON1 = '1' then
	cnt:= -2;	
	end if;
	if BUTTON2 = '1' then
	cnt:= -1;
	CS0 <= "0000";
	CS1 <= "0000";
	CM0 <= "0000";
	CM1 <= "0000";
	end if;	
	if BUTTON3 = '1' then 
	cnt:= -1;
	end if;
	if(OneKHZ=0)then
	Counter :=Counter+1;	     
		if (Counter=0) then
			 SEVEN_SEG_in<= CS0; 
			 Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			 Dot_Point <= '1';
		elsif (Counter=1) then
			  SEVEN_SEG_in<= CS1;
			  Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			  Dot_Point <= '1';
		elsif (Counter=2) then
			  SEVEN_SEG_in<= CM0;
			  Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			  Dot_Point <= '0';
		elsif (Counter=3) then
			  SEVEN_SEG_in <= CM1  ;
			  Anodes <= (Anodes(2 downto 0) & Anodes(3));	
			  Dot_Point <= '1';
		end if;
	end if;
	end if;--Switch end
   end if;--Rising CLock Loop End
   
	end process;
 ANODES_Out <= Anodes; 
 LED<=FF;
 with SEVEN_SEG_in select
 --SEVEN SEGMENT CONVERTER--
 SEVEN_SEG_Out  <= "0000001" when "0000",
             "1001111" when "0001",--1 
             "0010010" when "0010",--2 
             "0000110" when "0011",--3 
             "1001100" when "0100",--4 
             "0100100" when "0101",--5 
             "0100000" when "0110",--6 
             "0001111" when "0111",--7 
             "0000000" when "1000",--8 
             "0000100" when "1001",--9
             "1001000" when "1100",--H
				 "1000100" when "1101",--Y
				 "0001001" when "1010",--m (nn)--     
				 "0000001" when others;
end Behavioral;

-- THIS CODE WAS WRITTEN BY AHMET CAN TURGUT and DORUK RESMÝ --
-- ALL RIGHTS RESERVED WITH KOC UNIVERSITY POLICY of PALAGIRISM --
-- ELEC 204 2015 FALL 205 --
-- SEE FOR MORE INFO PDF FÝLE of THE DOCUMENTATION --
--
--
-- KOÇ UNÝVERSÝTY 2015 FALL
--
