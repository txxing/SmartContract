contract MC_MerchantAndConsumer{
    
    address public Regulators;
    address public Merchant;
    address public Consumer;
    
    string public productIPFS;
    bytes32 public hashk1;
    bytes32 public hashk2;
    uint public time;
    uint public ProductPrice;
    bytes32 public hash;
    uint public flag;
    address public ML_contractaddr;
    address public LC_contractaddr;
    uint public fine;
    uint public LCfee;
    bool public status;
    
    
    //Constructor, initializes parameters
    function MC_MerchantAndConsumer(){
        Regulators=0x5a84833752634dce71a61898787a2d8d7d2b6324;
        Merchant=0x4882e0800A2146455F4D266f1a91bbd0bC8Efd7b;
        Consumer=0x17245817d1D2C437B083B55bAe5Ff52900cC6bEa;
        productIPFS="Qm";
        hashk1=0x0a79670e261d27c33a1236b4ef259419a5443fbd756c99fd5420e82a985f35b8;//0100
        hashk2=0xe93b27b26c8c9eebdf30ab72d5f9d831d55728e024e6788c91840113a1ab0ac8;//0200
        ProductPrice=0.1 ether;
        time=now;
        flag=0;
        fine=0.1 ether;
        LCfee=0.1 ether;
        status=false;
        
    }

   
    modifier deposit(){
          if(msg.sender==Merchant){              
              require(msg.value==LCfee+fine);         
          }         
          else         
          {             
              require(msg.value==ProductPrice+fine);                                                                                                                                                                                                                                                                                                                                     
          }         
          _;
    }
    modifier onlyRegulators(){
        require(msg.sender==Regulators);
        _;
    }
    
    modifier onlyMerchant(){
        require(msg.sender==Merchant);
        _;
    }
    modifier onlyConsumer(){
        require(msg.sender==Consumer);
        _;
    }
    
    event MortgageSuccessful(string info,address executor);
    event CancelTransaction(string info,address executor);
    event PaymentSuccessful(string info);
    
   //Deposit funds by both parties
    function MC_Mortgage() payable public deposit{
        if(msg.sender==Merchant){
            MortgageSuccessful("Merchant Mortgage success",Merchant);
        }
        if(msg.sender==Consumer){
            MortgageSuccessful("Consumer Mortgage success",Consumer);
        }
    }

    //Payment to merchants
   function MC_Payment(string k)  onlyMerchant {
        if(keccak256(k)==(hashk1)&& now > (time+21 days))
        {
            Merchant.transfer(ProductPrice+fine+LCfee);
            Consumer.transfer(fine);
        }
    }
    //Refund to consumers
   function MC_Refund(string k)  onlyConsumer {
         if(keccak256(k)==(hashk2))
         {
             Merchant.transfer(LCfee+fine);
             Consumer.transfer(ProductPrice+fine);
         }
        else if(keccak256(k)==(hashk2)&&status==true)
        {
            Consumer.transfer(ProductPrice+LCfee+fine);
            Merchant.transfer(fine);
        }
    }
    //Get the ML contract address
    function MC_GetMLContractAddress(address _addr){
        ML_contractaddr==_addr;
        flag=1;
    }
    //Get LC contract address
    function MC_GetLCContractAddress(address _addr){
        LC_contractaddr==_addr;
        status=true;
    }
    //cancel the deal
    function MC_Cancellation() {
        if(flag==0&&msg.sender==Merchant)
        {
            CancelTransaction("The transaction has been cancelled",msg.sender);
            Merchant.transfer(LCfee+fine);
            Consumer.transfer(ProductPrice+fine);
        }
        else if(flag==0&&msg.sender==Consumer)
        {
            CancelTransaction("The transaction has been cancelled",msg.sender);
            Merchant.transfer(LCfee+fine);
            Consumer.transfer(ProductPrice+fine);
        }
        else 
        {
            CancelTransaction("Product has been issued, can not cancel the transaction",msg.sender);
        }
    }
    //Resolve the dispute
    function MC_MediationDispute() onlyRegulators {
        Regulators.transfer(ProductPrice+LCfee+2*fine);
    }
}
