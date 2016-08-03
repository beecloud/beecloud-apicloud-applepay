/*  
Title: bcapplepay  
Description: BeeCloud Apple Pay.  
*/

方法  

[pay](#a1)  
[getApiVersion](#a2)  
[canMakeApplePayments](#a3)  


# **概述**
bcapplepay 封装了Apple Pay(APPLE)支付接口。使用此模块可轻松完成Apple pay功能。  

**如需使用微信、支付宝、银联支付的模块请使用`beecloud`模块。**   

使用之前需要先到[BeeCloud](https://beecloud.cn) 注册认证，并[快速开始](https://beecloud.cn/apply)接入BeeCloud Apple Pay。  
更多信息请访问[BeeCloud帮助中心](http://help.beecloud.cn)&nbsp;&nbsp;&nbsp;[Apple Pay配置指导](https://developer.apple.com/library/prerelease/content/ApplePay_Guide/Configuration.html)。

# **配置**
注意: 使用此模块时,请勿同时勾选 `appleUnionPay` 模块.

**使用此模块之前需先配置config文件的Feature**

配置示例:

```js
<feature name="bcapplepay">
	<param name="bcAppID" value="c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" />
</feature>
```
配置描述:
  
	1.feature-name: bcapplepay.
	2.param-bcAppID: BeeCloud平台AppID.
	  
</br>
# **pay**<div id="a1"></div>
支付  
pay(params, callback);

## params

title：  

 * 类型：String  
 * 默认值：无  
 * 描述：订单描述。32个字节，最长支持16个汉字。
 
billno：

 * 类型：String  
 * 默认值：无  
 * 描述：订单号。8~32位字母和\或数字组合，必须保证在商户系统中唯一。建议根据当前时间生成订单号，格式为：yyyyMMddHHmmssSSS,"201508191436987"。
 
totalfee：  

 * 类型：Int  
 * 默认值：无  
 * 描述：订单金额。以分为单位，例如：100代表1元。
 
optional：  

 * 类型：Map(String, String) 
 * 默认值：无  
 * 描述：商户业务扩展，用于商户传递处理业务参数，会在**[webhook回调](https://beecloud.cn/doc/?index=webhook)**中返回。例：{'userID':'张三','mobile':'0512-86861620'}
    
## callback(ret, err)

ret:  

 * 类型：JSON对象  
 
内部字段：

```js
{
	result_code: 0,  //返回码，0代表成功
	result_msg: "支付成功", //返回信息
	err_detail: "" //当result_code不为0时，返回具体fail原因 
}
```
err:

 * 描述：所有信息都通过ret返回，err暂未启用。 

## 示例代码

```js
var payData = {
	title: "apicloud",
	totalfee: 1,
	billno: "201508191436987",
	optional: {'userID':'张三','mobile':'0512-86861620'}    
};

var demo = api.require('bcapplepay');
demo.pay(payData, payCallBack);

function payCallBack(ret, err) {
	api.toast({msg:ret.result_msg});
}	
```

## 补充说明

回调样例：

```js
//成功
{
	result_code: 0,
	result_msg: "支付成功",
	err_detail: ""
}
//失败
{
	result_code: -1,
	result_msg: "title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串",
	err_detail: "title 必须是长度不大于32个字节,最长16个汉字的字符串的合法字符串"
}
```

## 可用性

iOS系统  
可提供的1.0.0及更高版本  


# **getApiVersion**<div id="a2"></div>
获取API版本
  
getApiVersion(callback);

## callBack(ret, err)

ret:  

 * 类型：JSON对象  
 
内部字段：

```js
{
	apiVersion: "1.0.0" 
}
```
## 示例代码

```js
var demo = api.require('bcapplepay');
demo.getApiVersion(callBack);

function callBack(ret, err) {
	api.toast({msg:ret.apiVersion});
}
```

## 补充说明
无

## 可用性

iOS系统  
可提供的1.0.0及更高版本 


# **canMakeApplePayments**<div id="a3"></div>
判断是否支持Apple Pay
  
canMakeApplePayments(params, callback);

## params

cardType
 
  * 类型：Int
  * 默认值：0
  * 描述：0 代表不区分卡类型；1 代表借记卡；2 代表信用卡。

## callBack(ret, err)

ret:  

 * 类型：JSON对象  
 
内部字段：

```js
{
	status: true //支持
}
```
## 示例代码

```js
var demo = api.require('bcapplepay');
var params = {
	cardType: 0 
};
demo.canMakeApplePayments(params, callBack);

function callBack(ret, err) {
	api.toast({msg:ret.status});
}
```

## 补充说明
商户 App 在调用 Apple Pay 之前要注意根据此方法函数判断手机是否可用 Apple Pay 做应用内支付,从而判断是否显示 Apple Pay 支付按钮。

## 可用性

iOS系统 
可提供的1.0.0及更高版本



