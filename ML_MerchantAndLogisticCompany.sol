contract ML_MerchantAndLogisticCompany{
    address public Regulators;
    address public Merchant;
    address[4] public LogisticCompany;
    address public Consumer;
    
    string public productIPFS;
    bytes32 public hashk1;
    bytes32 public hashk2;
    uint public time;
    uint public ProductPrice;
    bytes32 public hash;
    uint  public s1;
    uint  public s2;
    uint public LCfee;
    bool public status;
    uint public fine;

    //构造函数，对参数进行初始化
    function ML_MerchantAndLogisticCompany(){
        Regulators=0x5a84833752634dce71a61898787a2d8d7d2b6324;
        Merchant=0x4882e0800A2146455F4D266f1a91bbd0bC8Efd7b;
        LogisticCompany=[0x7B0F7dB1D6cFabE4155e2013cE0E7141E9026965,0x3b78559c7D71C0120F69183bc2C76657D7d28EFF,0x4bCa32f38291c7F283b5B7646EbA0B4F8AD66359,0x2e2EB4f7dfBAfD78E30feafD52AcD85EbFca25f5];
        Consumer==0x17245817d1D2C437B083B55bAe5Ff52900cC6bEa;
        productIPFS="Qm";
        hashk1=0x0a79670e261d27c33a1236b4ef259419a5443fbd756c99fd5420e82a985f35b8;//0100
        hashk2=0xe93b27b26c8c9eebdf30ab72d5f9d831d55728e024e6788c91840113a1ab0ac8;//0200
        ProductPrice=0.01 ether;
        LCfee=0.01 ether;
        fine=0.01 ether;
        time=now;
    }

    event MortgageSuccessful(string info,address executor);
    event ProductStateUpdate(string info,address executor);
    event ProductReceive(string info,address executor);
    event ProductRefuse(string info,address executor,string reason);
    
    modifier deposit(){
        if(msg.sender==Merchant)
        {
           require(msg.value==2*LCfee+fine);
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
        require(msg.sender==Merchant);
        _;
    }
    //双方存入抵押金
    function ML_Mortgage()payable public deposit{
        if(msg.sender==Merchant){
            MortgageSuccessful("Merchant Mortgage success",Merchant);
        }
        if(msg.sender==LogisticCompany[0]){
            MortgageSuccessful("LogisticCompany Mortgage success",Consumer);
        }
    }
    //Update product information
    function ML_ProductUpdate(bool s){
        uint i=0;
        status=s;
        for(;i<4;i++)
        {
            if(msg.sender==LogisticCompany[i]&&status==true)
            {
                
                ProductStateUpdate("The current location of the product is",msg.sender);
                ProductStateUpdate("The product is intact",msg.sender);
                break;
                
            }
            else if(msg.sender==LogisticCompany[i]&&status==false)
            {
                ProductStateUpdate("The current location of the product is",msg.sender);
                ProductStateUpdate("The product is damaged",msg.sender);
                break;
            }
        }
    }
    //Payment function
    function ML_Payment(string k){
        if(msg.sender==LogisticCompany[0]&&keccak256(k)==hashk1&&now <=(time +7 days))
        {
            LogisticCompany[0].transfer(ProductPrice+LCfee+fine);
            Merchant.transfer(this.balance);
        }
        else if(msg.sender==LogisticCompany[0]&&keccak256(k)==hashk2&&now <= (time+14 days))
        {
            LogisticCompany[0].transfer(ProductPrice+2*LCfee+fine);
            Merchant.transfer(this.balance);
        }
    }
    //Product receiving information
    function ML_ProductConfirmation(string k, string reason){
        if(msg.sender==LogisticCompany[3]&&keccak256(k)==hashk1&&status==true)
        {
            
            ProductReceive("The product has been received by the Consumer",msg.sender);
        }
        else if(msg.sender==Consumer)
        {
            ProductRefuse("The product has been rejected by the Consumer",msg.sender,reason);
        }
    }
    //Resolve the dispute
    function ML_MediationDispute() onlyRegulators{
        Regulators.transfer(this.balance);
    }
}
