//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);

   
    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract THICCBSC is IERC20 {
    using SafeMath for uint256;
    using Address for address;

    address private ThiccFund=0xF41127F8d8701679D350B33a803bd2a3cA931bC1;
    address private Competitions=0x8B2029B9c7F95a93Dec977c17203B67b42642362;
    address private GameRewards=0x9E69859Eeb8E7aC675cC1F5CDFf976849CCf5AF0;
    address private Marketing=0x0f6Cf3100eA3EA3A3530E28A155EC0711dD05E4e;
    address private ProjectExpansion=0x87b1b8f0b86F080240a43BF4c433De5a3fC2F4F6;

     // here we store Token holder who have more then one THICC token.
    address[] private TokenHolders;
    
    // here we store another partner contract address.
    address private PartnerContractAddress;

    // here we store the NFT contract address
    address private nftContractAddress;
    // here we transfer burn token whenever transaction is happening and don't change this deadAddress.
    address private  deadAddress= 0x000000000000000000000000000000000000dEaD;
   
    
    uint256 private holderFeePercent = 4;
    uint256 private nftHolderFeePercent = 2;
    uint256 private partnerHoldersFeePercent = 5;
    uint256 private burnTokenPercent=1;

    mapping(address => bool) private _isBots;
    mapping(address => bool) private HolderExist;
    
    address private owner;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private minimumTokenHolder = 1*(10**9);
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1000000000000000 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "Thicc Token";
    string private _symbol = "THICC";
    uint8 private _decimals = 9;
    
    uint256 private _taxFee = 0;
    uint256 private _previousTaxFee = _taxFee;
    
    uint256 private _liquidityFee = 12;
    // This _botliquidityFee is for bot 
    uint256 private _botliquidityFee= 30;
    uint256 private _previousLiquidityFee = _liquidityFee;

    IUniswapV2Router02 private immutable uniswapV2Router;
    address private immutable uniswapV2Pair;

    mapping(bytes32 => bool) public processedHashes;

    enum Step { deposit }

    event depositToken(address from, address to, uint amount, Step indexed step);
    
    constructor () {
        owner = _msgSender();

       uint256 rToken= _rTotal/100;
       uint256 tToken=  _tTotal/100;

       uint256 rTokenOnePercent=rToken*1;
       uint256 tTokenOnePercent=tToken*1;


       uint256 rTokenTwoPercent=rToken*2;
       uint256 tTokenTwoPercent=tToken*2;

       uint256 rTokenFivePercent=rToken*5;
       uint256 tTokenFivePercent=tToken*5;

       uint256 rTokenNintyPercent=rToken*90;
       uint256 tTokenNintyPercent=tToken*90;

       
        _rOwned[_msgSender()] = rTokenNintyPercent;
        emit Transfer(address(0), _msgSender(), tTokenNintyPercent);

        _rOwned[ThiccFund] = rTokenOnePercent;
        emit Transfer(address(0), ThiccFund, tTokenOnePercent);

        _rOwned[Competitions] = rTokenOnePercent;
        emit Transfer(address(0), Competitions, tTokenOnePercent);

        _rOwned[GameRewards] = rTokenOnePercent;
        emit Transfer(address(0),GameRewards, tTokenOnePercent);

        _rOwned[Marketing] = rTokenTwoPercent;
        emit Transfer(address(0),Marketing, tTokenTwoPercent);

        _rOwned[ProjectExpansion] = rTokenFivePercent;
        emit Transfer(address(0), ProjectExpansion, tTokenFivePercent);

        TokenHolders.push(ThiccFund);
        TokenHolders.push(Competitions);
        TokenHolders.push(GameRewards);
        TokenHolders.push(Marketing);
        TokenHolders.push(ProjectExpansion);
        _isExcludedFromFee[ThiccFund] = true;
        _isExcludedFromFee[Competitions] = true;
         _isExcludedFromFee[GameRewards] = true;
        _isExcludedFromFee[Marketing] = true;
         _isExcludedFromFee[ProjectExpansion] = true;
         _isExcludedFromFee[PartnerContractAddress] = true;
         _isExcludedFromFee[nftContractAddress] = true;


       
        // pancakeswap mainnet router: 0x10ED43C718714eb63d5aA57B78B54704E256024E
        // pancakeswap testnet router: 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
         // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;
        
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner] = true;
        _isExcludedFromFee[address(this)] = true;
        
    }
    
    function _msgSender() internal view virtual returns(address) {
        return msg.sender;
    }

    modifier onlyOwner {
        _onlyOwner();
        _;
    }

    function _onlyOwner() private view {
        require(_msgSender() == owner);
    }
    
    // This function will send tokens from wallet to contract address | BURN
    function deposit(address to, uint256 amount) public {
        _tokenTransfer(_msgSender(), address(this), amount, false, false);
        emit depositToken(_msgSender(), to, amount, Step.deposit);
    }

    // This function will send tokens from contract address to ETH | MINT
    function claim(address to , uint256 amount, bytes32 transactionHash) public onlyOwner {
        require(processedHashes[transactionHash] == false, 'Already processed');
        processedHashes[transactionHash] = true;
        _tokenTransfer(address(this), to, amount, false, false);
    }

    // This function is used to get transaction fee when someone claim token to another chain.
    function bridgeFees() public payable {
        payable(address(this)).transfer(msg.value);
    }
    // This function is use to get ether from contract address in case owner wishes.
    function bridgeFeesToOwner() public onlyOwner{
        uint256 contractbnbBalance= address(this).balance;
        payable(owner).transfer(contractbnbBalance);

    }
    // for bridge use only
    function sendTokenToContract(uint256 _amount) public onlyOwner{
        _tokenTransfer(msg.sender,address(this),_amount,false,false);
    }
     // for bridge use only
    function ReceiveTokenFromContract(uint256 _amount) public onlyOwner{
        _tokenTransfer(address(this),msg.sender,_amount,false,false);
    }
    // This function is used to change GameRewards address
    function GameRewardsContract(address _changeGameRewardAddress) public onlyOwner{
        GameRewards= _changeGameRewardAddress;
    }

     // here we add/change partner contract address
    function addPartnerContractAddress(address _partnerContractaddress) public onlyOwner returns(bool){
    PartnerContractAddress = _partnerContractaddress;
    return true;
    }


    // here we add bot address manually 
    function BotAddress(address _BotAddress) public onlyOwner returns(bool){
    _isBots[_BotAddress]= true;
    return true;
    }

    // here we add token holder manually to the TokenHolders
    function addTokenHolders(address _tokenHolders) public onlyOwner returns(bool){
        TokenHolders.push(_tokenHolders);
        HolderExist[_tokenHolders] = true;

        return true;
    }
    // This function is used to change/add the NFT holder address.    
    function addNftContractAddress(address _nftHolderAddress)
        public
        onlyOwner
        returns (address)
    {
        nftContractAddress = _nftHolderAddress;
        return nftContractAddress;
    }
    // This function is used to clean token holder manually
    function cleanOldTokenHolders(uint size) public onlyOwner{
    uint256 popsize= size;
    address deleteaddress;
    for (uint256 i=0; i<size;i++){
        deleteaddress=TokenHolders[i];
        HolderExist[deleteaddress]= false;
        }
        uint256 j=0;
        for (uint256 i = size-1; i <TokenHolders.length; i++) {
            
            TokenHolders[j] = TokenHolders[i];
            j++;
        }
        //  uint256 maxsize= TokenHolders.length - (popsize-1);
        for(uint256 k=0; k<popsize-1;k++){
            TokenHolders.pop();

        }
    }
     //Removing the holder on demand or only creator can call this function in case he thinks some of the liquidity pool or other address should be removed.
    function removeHolder(address holderAddress) private returns (bool) {
        uint256 holderindex;
        

        for (uint256 i = 0; i < TokenHolders.length; i++) {
            if (TokenHolders[i] == holderAddress) {
                holderindex = i;
                break;
            }
        }
        if (holderindex < 0 || holderindex >= TokenHolders.length) {
            return false;
        } else if (TokenHolders.length == 1) {
            TokenHolders.pop();
            return true;
        } else if (holderindex == TokenHolders.length - 1) {
            TokenHolders.pop();
            return true;
        } else {
            for (uint256 i = holderindex; i < TokenHolders.length - 1; i++) {
                TokenHolders[i] = TokenHolders[i + 1];
            }
            TokenHolders.pop();
            return true;
        }
    }


    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }


    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        
        if(amount > minimumTokenHolder && !_isBots[recipient] && !HolderExist[recipient])
            {
                TokenHolders.push(recipient);
                HolderExist[recipient] = true;
            }
        return true;
    }

    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function deliver(uint256 tAmount) private {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount,true);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) private view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount,true);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount,true);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner() {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount,bool isBot) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount,isBot);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
        function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

     //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount,bool isBot) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount,isBot);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
    }

    function _getTValues(uint256 tAmount,bool isBot) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount,isBot);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
    
    // here we calculate the actual distribution of 12%
    function _takeLiquidity(uint256 tLiquidity) private {

        uint256 onePercentRate = tLiquidity/12;
        uint256 tLiquidityHolder = onePercentRate*holderFeePercent;
        uint256 tLiquidityPartnerHolder = onePercentRate*partnerHoldersFeePercent;
        uint256 tLiquidityNftHolder=  onePercentRate*nftHolderFeePercent;
        uint256 tLiquidityBurnAmount= onePercentRate*burnTokenPercent;

        // here we calculate 4% liquidity for token holder 
        uint256 currentRate = _getRate();
        uint256 rLiquidityHolder = tLiquidityHolder.mul(currentRate);
        uint256 rLiquidityPerHolder = rLiquidityHolder/TokenHolders.length;
        uint256 tLiquidityPerHolder = tLiquidityHolder/TokenHolders.length;
        // here we calculate 5% liquidity for partner holder 
        uint256 rLiquidityPartner = tLiquidityPartnerHolder.mul(currentRate);

        // here we calculate 1% liquidity for brun token on every swap(sell,buy)

        uint256 rLiquidityBurn= tLiquidityBurnAmount.mul(currentRate);

        // here we calculate 2% liquidity for NFT holder 

        uint256 rLiquidityNFT= tLiquidityNftHolder.mul(currentRate);


        // here we transfer 2% to NFT contract address
        _rOwned[nftContractAddress] = _rOwned[nftContractAddress].add(rLiquidityNFT);
    
        _tOwned[nftContractAddress] = _tOwned[nftContractAddress].add(tLiquidityNftHolder);
        
        // here we burn 2% token on every swap(buy and sell)
        _rOwned[deadAddress] = _rOwned[deadAddress].add(rLiquidityBurn);
        
        _tOwned[deadAddress] = _tOwned[deadAddress].add(tLiquidityBurnAmount);
        
        //  here we transfer 4% to token holders

        for(uint256 i= 0; i< TokenHolders.length ; i++)
        {
        _rOwned[TokenHolders[i]] = _rOwned[TokenHolders[i]].add(rLiquidityPerHolder);
        
        _tOwned[TokenHolders[i]] = _tOwned[TokenHolders[i]].add(tLiquidityPerHolder);
        }
        //  here we transfer 5% to PartnerContractAddress  holders

        _rOwned[PartnerContractAddress] = _rOwned[PartnerContractAddress].add(rLiquidityPartner);
        _tOwned[PartnerContractAddress] = _tOwned[PartnerContractAddress].add(tLiquidityPartnerHolder); 
            
        
    }
     function _takeBotLiquidity(uint256 tLiquidity) private {

        uint256 currentRate = _getRate();
        uint256 rLiquiditybotHolder = tLiquidity.mul(currentRate);
        uint256 rLiquidityPerbotHolder = rLiquiditybotHolder/TokenHolders.length;
        uint256 tLiquidityPerbotHolder = tLiquidity/TokenHolders.length;

        for(uint256 i= 0; i< TokenHolders.length ; i++)
            {
            _rOwned[TokenHolders[i]] = _rOwned[TokenHolders[i]].add(rLiquidityPerbotHolder);
               
            _tOwned[TokenHolders[i]] = _tOwned[TokenHolders[i]].add(tLiquidityPerbotHolder);
            }
        }
    
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10**2
        );
    }

    function calculateLiquidityFee(uint256 _amount,bool isBot) private view returns (uint256) {

         if(isBot)
        {
        return _amount.mul(_botliquidityFee).div(10**2);
        }
        else{
            return _amount.mul(_liquidityFee).div(10**2);
        }
    }
    
    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0) return;
        
        _previousTaxFee = _taxFee;
        _previousLiquidityFee = _liquidityFee;
        
        _taxFee = 0;
        _liquidityFee = 0;
    }
    
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _liquidityFee = _previousLiquidityFee;
    }
    function _approve(address _owner, address spender, uint256 amount) private {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Amount must be greater than zero");
        bool isBot= false;



       if(!_isBots[from] && HolderExist[from]){
            uint256 beforeTransferBalance = balanceOf(from);
            uint256 remainingTokenBalance = beforeTransferBalance - amount;
            if(remainingTokenBalance < minimumTokenHolder)
            {
                removeHolder(from);
                HolderExist[from] = false;
                        
            }
        }
        
        //indicates if fee should be deducted from transfer
        bool takeFee = true;
        
        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }
        if(_isBots[from] || _isBots[to])
        {
        isBot = true;

        }
        
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee,isBot);
    }

    
     
    
    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee,bool isBot) private {
        if(!takeFee)
            removeAllFee();
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount,isBot);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount,isBot); 
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount,isBot);
        } else {
            _transferStandard(sender, recipient, amount,isBot);
        }
        
        if(!takeFee)
            restoreAllFee();
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount,bool isBot) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount,isBot);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        
        if(_isBots[recipient] || _isBots[sender] ){
            _takeBotLiquidity(tLiquidity);
        }
        else{
            _takeLiquidity(tLiquidity);
        }
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount,bool isBot) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount,isBot);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

     function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount,bool isBot) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount,isBot);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
}
