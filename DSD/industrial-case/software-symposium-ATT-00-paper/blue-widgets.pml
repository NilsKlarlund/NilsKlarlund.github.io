<?dsd URI="xpml-att.dsd"?>

<XPML xmlns:DSD="http://www.brics.dk/DSD">
  <head>
    <maintainer address="karam@research.att.com" loglevel="1"/>
    <application name="sellwidgets"/>
    <title> The Widget Sales Application </title>
  </head>
  <body>
    <audio url="/audioclips/welcome-message.vox"/>
    <form action="/cgi-bin/place-order">
      <input type="text" size="6" maxlength="6" name="member_no">
	<initial>Please enter your 6 digit membership number.</initial>
      </input>   
      <select name="product_code">
	<initial>Please select your payment choice.</initial>
	<option value="PDC0001">For blue widgets at $2.00</option>
	<option value="PDC0002">For pink widgets at $5.00</option>
	<option value="PDC0003">For pocket protectors at $10.00</option>
      </select>
      <select name="form_of_payment">
	<initial>Please select your payment choice.</initial>
	<option dtmf="9" value="credit"> For your credit card on file.</option>
	<option dtmf="99" value="invoice"> For invoicing.</option>
      </select>
      We now have the basic information to complete your order. 
      Please wait while we post your order.
      <input type="submit"/>
    </form>
  </body>
</XPML>