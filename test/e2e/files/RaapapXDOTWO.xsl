<?xml version="1.0" encoding="UTF-8"?>
<!--
	$Log: RaapapXDOTWO.xsl,v $
	Revision 1.16  2018/02/27 07:54:59  Ncar.Ip
	Update LM v5, ISCINT-25468
	
	Revision 1.15  2018/02/26 08:09:09  Ncar.Ip
	Update LM v5, ISCINT-25468
	
	Revision 1.14  2017/01/18 08:03:08  Shunkin.Chan
	Update LM V4, ISCINT-16358
	
	Revision 1.13  2016/10/13 10:21:22  William.Leung
	no message
	
	Revision 1.12  2016/10/13 07:47:59  William.Leung
	no message
	
	Revision 1.11  2016/08/29 06:07:19  William.Leung
	v3 logical mapping
	
	Revision 1.10  2016/08/05 03:30:59  Shunkin.Chan
	Commit
	
	Revision 1.9  2016/04/20 04:21:40  William.Leung
	no message
	
	Revision 1.8  2016/04/20 04:12:49  William.Leung
	v2 logical mapping
	
	Revision 1.7  2016/04/12 08:30:44  William.Leung
	no message
	
	Revision 1.6  2016/04/12 07:35:25  William.Leung
	no message
	
	Revision 1.5  2016/04/12 06:48:14  William.Leung
	no message
	
	Revision 1.4  2016/04/12 04:27:10  William.Leung
	no message
	
	Revision 1.3  2016/04/12 02:37:46  William.Leung
	no message
	
	Revision 1.2  2016/04/12 01:14:46  William.Leung
	Initial version
	
	Revision 1.1  2016/04/11 06:04:54  William.Leung
	First entry through new_msg.ksh
	
	Revision 1.19  2009/10/12 09:16:15  Sven.Willenbuecher
	knfunc:knNbr -> knfunc:kn-nbr
	
	Revision 1.18  2009/06/12 07:42:12  D.Mueller
	added description of the knfunction java extension
	
	Revision 1.17  2009/06/11 10:13:58  D.Mueller
	correction regarding scenario
	

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/04/xpath-datatypes"
                xmlns:knfunc="de.kn.xslt.extensions.KnFunctions" xmlns:eimf="de.ei.xslt.extensions.MetaFile" xmlns:eicf="de.ei.xslt.extensions.ControlFile" xmlns:user="extend-functions" xmlns:eicnt="de.ei.xslt.extensions.Counter"
                xmlns:eienv="de.ei.xslt.extensions.Environment" xmlns:plausi="de.ei.xslt.extensions.PlausiChecker" xmlns:dc="de.ei.xslt.extensions.DateConv" extension-element-prefixes="fn xs xdt knfunc eimf eicf eicnt eienv plausi dc user">

	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/">
		<xsl:variable name="KN_DATE_HKT" select="eienv:get-env('KN_DATE_HKT')"/>
		<xsl:variable name="KN_TIME_HKT" select="eienv:get-env('KN_PROT_TIME_HKT')"/>

		<xsl:variable name="ENV">
			<xsl:choose>
				<xsl:when test="eienv:get-env('INSTANCEMODE') = 'P'">P</xsl:when>
				<xsl:otherwise>T</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:for-each select="SHIPPING/SOHEAD">
			<xsl:variable name="OrdNo" as="xs:string" select="APO_NO"/>
			<xsl:variable name="OrdTyp" as="xs:string">
				<xsl:value-of select="user:conv(2,CUSTOMER_ID)"/>
			</xsl:variable>
			<xsl:variable name="REMOTENAME" as="xs:string" select="knfunc:create-tws-member()"/>
			<xsl:result-document href="{$REMOTENAME}" omit-xml-declaration="no">
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME,'REMOTENAME',$REMOTENAME))"/>
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME,'EMPTY_ALLOWED','ON'))"/>
				<xsl:message terminate="no" select="concat('INFO:RECORDLENGTH:',eimf:set-local($REMOTENAME,'RECORDLENGTH','1560'))"/>
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME,'OUTPUT_FORMAT','flat'))"/>
				<xsl:variable name="ItemCnt" select="count(current()/ITEMS/SOITEMLIST)"/>
				<xsl:variable name="To_Ctry">
					<xsl:value-of select="user:conv(6,CUSTOMER_ID)"/>
				</xsl:variable>
				<xsl:variable name="Ref1">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">
							<xsl:value-of select="user:conv(3,CUSTOMER_ID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="CPO_Number"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Ref2">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">
							<xsl:value-of select="user:conv(4,CUSTOMER_ID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Ref3">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">
							<xsl:value-of select="user:conv(5,CUSTOMER_ID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Status">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">GOO</xsl:when>
						<xsl:otherwise>XDO</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="RefDate_1">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">
							<xsl:value-of select="user:conv(9,WARNING)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="RefDate_2">
					<xsl:choose>
						<xsl:when test="CPO_Number = ''">
							<xsl:value-of select="user:conv(10,WARNING)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<WHSORDER_0480>
					<Message>
						<KJ>
							<XXRCTY>KJ</XXRCTY>
							<XXTRPA>AAPSHA01</XXTRPA>
							<XXDOTY>WHSORDER</XXDOTY>
							<XXDONO>
								<xsl:value-of select="$OrdNo"/>
							</XXDONO>
							<KJCLIE>AAPSHA01</KJCLIE>
							<KJCORF>
								<xsl:value-of select="$OrdNo"/>
							</KJCORF>
							<KJDEPO>SH6</KJDEPO>
							<KJORDT>
								<xsl:value-of select="$OrdTyp"/>
							</KJORDT>
							<KJSRVL>00</KJSRVL>
							<KJSRVT>1</KJSRVT>
							<KJRSDT>
								<xsl:value-of select="$KN_DATE_HKT"/>
							</KJRSDT>
							<KJRSTM>
								<xsl:value-of select="$KN_TIME_HKT"/>
							</KJRSTM>
							<KJRCDT>
								<xsl:value-of select="ETS"/>
							</KJRCDT>
							<KJRCTM>000000</KJRCTM>
							<KJSSDT>
								<xsl:value-of select="$KN_DATE_HKT"/>
							</KJSSDT>
							<KJSSTM>
								<xsl:value-of select="$KN_TIME_HKT"/>
							</KJSSTM>
							<KJSCDT>
								<xsl:value-of select="ETS"/>
							</KJSCDT>
							<KJSCTM>000000</KJSCTM>
						</KJ>
						<LF>
							<XXRCTY>LF</XXRCTY>
							<XXTRPA>AAPSHA01</XXTRPA>
							<XXDOTY>WHSORDER</XXDOTY>
							<XXDONO>
								<xsl:value-of select="$OrdNo"/>
							</XXDONO>
							<LFDEPO>SH6</LFDEPO>
							<LFCLIE>AAPSHA01</LFCLIE>
							<LFCORF>
								<xsl:value-of select="$OrdNo"/>
							</LFCORF>
							<LFINVN>
								<xsl:value-of select="$OrdNo"/>
							</LFINVN>
							<LFINVD>
								<xsl:value-of select="$KN_DATE_HKT"/>
							</LFINVD>
						</LF>
						<KK>
							<XXRCTY>KK</XXRCTY>
							<XXTRPA>AAPSHA01</XXTRPA>
							<XXDOTY>WHSORDER</XXDOTY>
							<XXDONO>
								<xsl:value-of select="$OrdNo"/>
							</XXDONO>
							<KKCLIE>AAPSHA01</KKCLIE>
							<KKCORF>
								<xsl:value-of select="$OrdNo"/>
							</KKCORF>
							<KKADTY>2</KKADTY>
							<KKNAME>
								<xsl:value-of select="CUSTOMER_NAME"/>
							</KKNAME>
							<KKADD1>
								<xsl:value-of select="substring(SHIP_TO,1,35)"/>
							</KKADD1>
							<KKADD2>
								<xsl:value-of select="substring(SHIP_TO,36,35)"/>
							</KKADD2>
							<KKADD3>
								<xsl:value-of select="substring(SHIP_TO,71,35)"/>
							</KKADD3>
							<KKADD4>
								<xsl:value-of select="substring(SHIP_TO,106,35)"/>
							</KKADD4>
							<KKCTRY>
								<xsl:value-of select="$To_Ctry"/>
							</KKCTRY>
							<KKECLI>
								<xsl:value-of select="CUSTOMER_ID"/>
							</KKECLI>
						</KK>
						<xsl:for-each select="current()/ITEMS/SOITEMLIST">
							<xsl:variable name="KLSEQ" as="xs:string" select="format-number(position(), '000000')"/>
							<xsl:variable name="KLLNO" as="xs:string" select="format-number(position(), '0000')"/>
							<xsl:variable name="FlrCnt" select="floor(number($KLLNO) div 999)"/>
							<G1>
								<KL>
									<XXRCTY>KL</XXRCTY>
									<XXTRPA>AAPSHA01</XXTRPA>
									<XXDOTY>WHSORDER</XXDOTY>
									<XXDONO>
										<xsl:value-of select="../../APO_NO"/>
									</XXDONO>
									<XXSEQ1>
										<xsl:value-of select="$KLSEQ"/>
									</XXSEQ1>
									<KLCLIE>AAPSHA01</KLCLIE>
									<KLCORF>
										<xsl:value-of select="../../APO_NO"/>
									</KLCORF>
									<KLLNNO>
										<xsl:choose>
											<xsl:when test="number($KLLNO) &lt; 1000">
												<xsl:value-of select="substring($KLLNO,2,3)"/>
											</xsl:when>
											<xsl:when test="number($KLLNO) &gt; (999 * $FlrCnt) and number($KLLNO) &lt; (999 * ($FlrCnt + 1))">
												<xsl:value-of select="format-number($FlrCnt, '000')"/>
											</xsl:when>
											<xsl:when test="number($KLLNO) = (999 * $FlrCnt)">
												<xsl:value-of select="format-number($FlrCnt - 1, '000')"/>
											</xsl:when>
											<xsl:otherwise>999</xsl:otherwise>
										</xsl:choose>
									</KLLNNO>
									<KLADTC>
										<xsl:value-of select="SKU_NO"/>
									</KLADTC>
									<KLARR1>
										<xsl:value-of select="$Ref1"/>
									</KLARR1>
									<KLSSTS>
										<xsl:value-of select="$Status"/>
									</KLSSTS>
									<KLQUAN>
										<xsl:value-of select="SO_QTY"/>
									</KLQUAN>
									<KLDES1>
										<xsl:value-of select="substring(SKU_DESCRIPTION,1,35)"/>
									</KLDES1>
									<KLDES2>
										<xsl:value-of select="substring(SKU_DESCRIPTION,36,35)"/>
									</KLDES2>
									<KLARR2>
										<xsl:value-of select="$Ref2"/>
									</KLARR2>
									<KLARR3>
										<xsl:value-of select="$Ref3"/>
									</KLARR3>
									<KLUNTP>
										<xsl:value-of select="format-number((SKU_UNITPRICE * 1000000) div 1000, '#000')"/>
									</KLUNTP>
									<KLUOMC>
										<xsl:value-of select="user:conv(1,APO_UOM)"/>
									</KLUOMC>
									<KLCURR>
										<xsl:value-of select="CURRENCY"/>
									</KLCURR>
									<KLLINE>
										<xsl:choose>
											<xsl:when test="number($KLLNO) &lt; 1000">000</xsl:when>
											<xsl:when test="number($KLLNO) &gt; (999 * $FlrCnt) and number($KLLNO) &lt; (999 * ($FlrCnt + 1))">
												<xsl:value-of select="format-number((number($KLLNO) - (999 * $FlrCnt)), '000')"/>
											</xsl:when>
											<xsl:when test="number($KLLNO) = (999 * $FlrCnt)">999</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring($KLLNO,2,3)"/>
											</xsl:otherwise>
										</xsl:choose>
									</KLLINE>
									<KLCARF>
										<xsl:value-of select="CARTON_PACK_QTY"/>
									</KLCARF>
									<KLARD1>
										<xsl:value-of select="$RefDate_1"/>
									</KLARD1>
									<KLARD2>
										<xsl:value-of select="$RefDate_1"/>
									</KLARD2>
									<KLSPOL>
										<xsl:value-of select="SO_SERNO"/>
									</KLSPOL>
								</KL>
							</G1>
						</xsl:for-each>
					</Message>
				</WHSORDER_0480>
			</xsl:result-document>

			<!-- generate e-mail for processed file -->
			<xsl:variable name="emailkey" as="xs:string" select="concat('SH6_','AAPSHA01_',$OrdTyp)"/>
			<xsl:variable name="emailAddress" as="xs:string">
				<xsl:choose>
					<xsl:when test="$ENV ='P'">
						<xsl:call-template name="conv">
							<xsl:with-param name="TableNumber">7</xsl:with-param>
							<xsl:with-param name="Key">
								<xsl:value-of select="$emailkey"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ENV ='T'">
						<xsl:call-template name="conv">
							<xsl:with-param name="TableNumber">8</xsl:with-param>
							<xsl:with-param name="Key">
								<xsl:value-of select="$emailkey"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>kelvin.liang@kuehne-nagel.com</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="REMOTENAME2" select="concat('AAP_WHSORDER_ALERTMAIL_',$KN_DATE_HKT,$KN_TIME_HKT,'.txt')"/>
			<xsl:variable name="Subject" select="concat('New AAP Outbound Order - ',$OrdNo)"/>
			<xsl:result-document href="{$REMOTENAME2}" method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="no">
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME2,'UPLOADKEY','RaapapXDOTWO_ALERTMAIL'))"/>
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME2,'REMOTENAME',$REMOTENAME2))"/>
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME2,'TARGET',$emailAddress))"/>
				<xsl:message terminate="no" select="concat('DEBUG: ',eimf:set-local($REMOTENAME2,'UD2',$Subject))"/>
				<Mail_001>
					<Message>
						<Contents>
							<Heading>The following WHSORDER message from customer AAP has been proceessed:</Heading>
							<Detail>&#xA;&#xA;Client ID: AAPSHA01</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;Order Number: ',$OrdNo)"/>
							</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;Order Type: ',$OrdTyp)"/>
							</Detail>
							<Detail>&#xA;Operation Process: Outbound</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;&#xA;ETA: ',substring(ETS,1,4),'-',substring(ETS,5,2),'-',substring(ETS,7,2))"/>
							</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;Customer ID: ',CUSTOMER_ID)"/>
							</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;&#xA;Order Creation Date: ',substring($KN_DATE_HKT,1,4),'-',substring($KN_DATE_HKT,5,2),'-',substring($KN_DATE_HKT,7,2))"/>
							</Detail>
							<Detail>
								<xsl:value-of select="concat('&#xA;Order Creation Time: ',substring($KN_TIME_HKT,1,2),':',substring($KN_TIME_HKT,3,2),':',substring($KN_TIME_HKT,5,2))"/>
							</Detail>
						</Contents>
					</Message>
				</Mail_001>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>


	<!-- Define the remotename. This template needs to be called within the main
      section, otherwise it does not get executed -->
	<xsl:template name="setRemoteName">
		<xsl:variable name="REMOTENAME">
			<!-- Change this to suit your needs for the remotename or just delete the whole template -->
			<xsl:value-of select="concat('TDETSTIBTEST.W',knfunc:create-tws-member())"/>
		</xsl:variable>
		<xsl:message terminate="no">
			<xsl:value-of select="concat('DEBUG: ',eimf:set-local('stdout','REMOTENAME',$REMOTENAME))"/>
		</xsl:message>
	</xsl:template>

	<xsl:function name="user:conv">
		<xsl:param name="TableNumber"/>
		<xsl:param name="Key"/>
		<xsl:call-template name="conv">
			<xsl:with-param name="TableNumber" select="$TableNumber"/>
			<xsl:with-param name="Key" select="$Key"/>
		</xsl:call-template>
	</xsl:function>

	<xsl:template name="conv">
		<xsl:param name="TableNumber"/>
		<xsl:param name="Key"/>
		<xsl:variable name="URI" select="'../tabs/RaapapXDOTWO.xml'"/>
		<xsl:choose>
			<xsl:when test="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Value[@Key=$Key]">
				<xsl:value-of select="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Value[@Key=$Key]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Default">
						<xsl:value-of select="document($URI)/Tables/Table[@TableNumber=$TableNumber]/Default"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message terminate="yes">
							<xsl:value-of select="concat('TABLENUMBER ',$TableNumber,' TABLEERROR: ', document($URI)/Tables/Table[@TableNumber=$TableNumber]/Error,$Key)"/>
						</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="testfile.xml" userelativepaths="yes" externalpreview="no" url="..\tst\testfile.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
		          commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
		<scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\tst\ORD_SO_6240158_20160823143405_000003.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="no" profilemode="0" profiledepth=""
		          profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
		<scenario default="no" name="Scenario2" userelativepaths="yes" externalpreview="no" url="..\tst\inbound.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
		          commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="">
			<advancedProp name="sInitialMode" value=""/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="..\xsd\WHSORDER_0480.xsd" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no">
			<SourceSchema srcSchemaPath="..\xsd\SO_001.xsd" srcSchemaRoot="" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/>
		</MapperInfo>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->