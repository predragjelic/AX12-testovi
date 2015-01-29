
#define ID1 0x01                         
#define ID2 0x02 
#define ID3 0x03                         
#define ID4 0x04            
#define ID5 0x05                         
#define ID6 0x06 
#define ID7 0x07                         
#define ID8 0x08                         

void prijem_paketa (void);
void prijem_paketaPosition(void);
void prijem_paketaMoving(void);
void blokiranje_predaje(void); 
void oslobadjanje_predaje(void); 
void oslobadjanje_prijema(void);
void ax12_goto(int ID, short pozicija1,short brzina1);
void ax12_moving_status(int ID);
void ax12_position_status(int ID);
void ax12_alarm_shutdown(int ID);
void ax12_torque_enable(int ID);
void ax12_torque_limit(int ID, int value);
void ax12_id_set(int ID);
void ax12_reset(int ID);