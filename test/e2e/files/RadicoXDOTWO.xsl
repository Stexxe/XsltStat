<?xml version="1.0" encoding="UTF-8"?>
<!--
	$Log: RadicoXDOTWO.xsl,v $
	Revision 1.20  2017/02/01 16:08:33  Marcelo.Casagrande
	LM Ver 2.2
	
	Revision 1.19  2016/11/23 11:46:56  Marcelo.Casagrande
	LM Ver 2.1
	
	Revision 1.18  2016/11/09 22:40:14  Marcelo.Casagrande
	LM Ver 2.0
	
	Revision 1.17  2016/11/07 23:03:46  Marcelo.Casagrande
	REPLACE_CHAR added in xslt
	
	Revision 1.16  2016/11/07 22:04:39  Marcelo.Casagrande
	Rollback encoding to ISO-8859-1
	
	Revision 1.14  2016/10/03 13:57:24  Pablo.Cappone
	Bugfix
	
	Revision 1.13  2016/09/30 19:17:07  Pablo.Cappone
	LM 1.9
	
	Revision 1.12  2016/09/29 17:32:17  Pablo.Cappone
	Adjusment
	
	Revision 1.11  2016/09/08 19:14:07  Pablo.Cappone
	LM 1.8
	
	Revision 1.10  2016/08/04 19:37:44  Pablo.Cappone
	LM Ver 1.7
	
	Revision 1.9  2016/06/24 14:54:17  Marcelo.Casagrande
	LM Ver 1.6
	
	Revision 1.8  2016/06/15 12:19:52  Pablo.Cappone
	LM 1.5b adjusment
	
	Revision 1.7  2016/06/10 18:55:09  Pablo.Cappone
	LM 1.5b
	
	Revision 1.6  2016/06/10 17:21:03  Pablo.Cappone
	LM 1.5 (LM 1.4 - Comm change)
	
	Revision 1.5  2016/05/23 14:03:09  Pablo.Cappone
	LM 1.3
	
	Revision 1.4  2016/05/19 12:34:52  Pablo.Cappone
	LM 1.1 / 1.2
	
	Revision 1.3  2016/05/17 19:20:00  Pablo.Cappone
	LM 1.0 adjusment
	
	Revision 1.2  2016/04/22 14:22:18  Pablo.Cappone
	LM Ver 1.0
	
	Revision 1.1  2016/04/19 14:44:59  Pablo.Cappone
	First entry through new_msg.ksh
	
	Revision 1.19  2009/10/12 09:16:15  Sven.Willenbuecher
	knfunc:knNbr -> knfunc:kn-nbr
	
	Revision 1.18  2009/06/12 07:42:12  D.Mueller
	added description of the knfunction java extension
	
	Revision 1.17  2009/06/11 10:13:58  D.Mueller
	correction regarding scenario
	

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdt="http://www.w3.org/2005/04/xpath-datatypes"
                xmlns:knfunc="de.kn.xslt.extensions.KnFunctions" xmlns:eimf="de.ei.xslt.extensions.MetaFile" xmlns:eicf="de.ei.xslt.extensions.ControlFile" xmlns:eicnt="de.ei.xslt.extensions.Counter" xmlns:eienv="de.ei.xslt.extensions.Environment"
                xmlns:plausi="de.ei.xslt.extensions.PlausiChecker" xmlns:dc="de.ei.xslt.extensions.DateConv" xmlns:pnb="http://www.tibco.com/schemas/3PLCO_DeliveryNote_CDM_SUB/Adapters/3PLCO.Inbound/SharedResources/Schema/Schema.xsd"
                extension-element-prefixes="fn xs xdt knfunc eimf eicf eicnt eienv plausi dc pnb">



	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:variable name="documentType">WHSORDER</xsl:variable>
	<xsl:variable name="client">ADIDBG201</xsl:variable>
	<xsl:variable name="depot">BG2</xsl:variable>
	<xsl:variable name="creationDate" as="xs:string" select="format-date(current-date(), '[Y0001][M01][D01]')"/>
	<xsl:variable name="creationTime" as="xs:string" select="format-time(current-time(), '[H01][m01]')"/>
	<xsl:variable name="DateTimeCO" select="substring(replace(string(adjust-dateTime-to-timezone(current-dateTime(),xs:dayTimeDuration('-PT5H'))),'-',''),1,8)"/>
	<xsl:variable name="lineLimit" select="number('999')"/>


	<xsl:template match="pnb:PickingNoteBridge">
		<xsl:variable name="filename">
			<xsl:value-of select="concat('TCOBG2ADI2.W',knfunc:create-tws-member())"/>
		</xsl:variable>
		<xsl:result-document href="{$filename}">
			<xsl:message terminate="no">
				<xsl:value-of select="concat('DEBUG: REMOTENAME:',eimf:set-local($filename,'REMOTENAME',$filename))"/>
				<xsl:value-of select="concat('DEBUG: OUTPUT_FORMAT:',eimf:set-local($filename,'OUTPUT_FORMAT','flat'))"/>
				<xsl:value-of select="concat('DEBUG: OUTPUT_ENCODING:',eimf:set-global('OUTPUT_ENCODING','ISO-8859-1'))"/>
				<xsl:value-of select="concat('DEBUG: REPLACE_CHAR:',eimf:set-local($filename,'REPLACE_CHAR','.'))"/>
			</xsl:message>

			<WHSORDER_0360>
				<xsl:for-each select="pnb:PickNote">
					<KJ>
						<XXRCTY>
							<xsl:value-of select="'KJ'"/>
						</XXRCTY>
						<XXTRPA>
							<xsl:value-of select="$client"/>
						</XXTRPA>
						<XXDOTY>
							<xsl:value-of select="$documentType"/>
						</XXDOTY>
						<XXDONO>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</XXDONO>
						<KJCLIE>
							<xsl:value-of select="$client"/>
						</KJCLIE>
						<KJCORF>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</KJCORF>
						<KJDEPO>
							<xsl:value-of select="$depot"/>
						</KJDEPO>
						<KJCCNO>
							<xsl:choose>
								<xsl:when test="pnb:VASRequired = 'Y'">
									<xsl:value-of select="'VAS'"/>
								</xsl:when>
							</xsl:choose>
						</KJCCNO>
						<KJCONO>
							<xsl:value-of select="pnb:SalesOrderNbr"/>
						</KJCONO>
						<KJRETA>
							<xsl:value-of select="pnb:ShippingConditions"/>
						</KJRETA>
						<KJTRGP>
							<xsl:value-of select="pnb:DeliveryType"/>
						</KJTRGP>
						<KJORDT>
							<xsl:choose>
								<xsl:when test="pnb:SalesOrderType = 'ECO'">
									<xsl:value-of select="'ADE'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'ADO'"/>
								</xsl:otherwise>
							</xsl:choose>
						</KJORDT>
						<KJCODS>
							<xsl:value-of select="pnb:CustomerPONbr"/>
						</KJCODS>
						<KJHAND>
							<xsl:value-of select="pnb:PickNoteText/pnb:Text"/>
						</KJHAND>
						<KJCLCD>
							<xsl:choose>
								<xsl:when test="pnb:SalesOrderType = 'ECO'">
									<xsl:value-of select="pnb:Address/pnb:LastName"/>
								</xsl:when>
							</xsl:choose>
						</KJCLCD>
						<KJCOCD>
							<xsl:value-of select="pnb:PlannedGoodsIssueDate"/>
						</KJCOCD>
						<KJDACD>
							<xsl:value-of select="pnb:BatchCtlNbr"/>
						</KJDACD>
						<KJRSDT>
							<xsl:value-of select="$DateTimeCO"/>
						</KJRSDT>
						<KJRCDT>
							<xsl:value-of select="$DateTimeCO"/>
						</KJRCDT>
						<KJSSDT>
							<xsl:value-of select="$DateTimeCO"/>
						</KJSSDT>
						<KJSCDT>
							<xsl:value-of select="$DateTimeCO"/>
						</KJSCDT>
						<KJCOAC>
							<xsl:value-of select="$client"/>
						</KJCOAC>
						<xsl:variable name="KJCARRtmp">
							<xsl:call-template name="conv">
								<xsl:with-param name="TableNumber">1</xsl:with-param>
								<xsl:with-param name="Key" select="./pnb:Address/pnb:PostalCode"/>
							</xsl:call-template>
						</xsl:variable>
						<KJCARR>
							<xsl:choose>
								<xsl:when test="pnb:SalesOrderType = 'ECO' and $KJCARRtmp = 'Yes'">
									<xsl:value-of select="'FEDP'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'FEDA'"/>
								</xsl:otherwise>
							</xsl:choose>
						</KJCARR>
						<KJGRSW>
							<xsl:value-of select="translate(pnb:GrossWeight , '.' , '')"/>
						</KJGRSW>
						<KJNETW>
							<xsl:value-of select="translate(pnb:NetWeight , '.' , '')"/>
						</KJNETW>
						<KJVOL>
							<xsl:value-of select="translate(pnb:Volume , '.' , '')"/>
						</KJVOL>
						<KJWIND>
							<xsl:value-of select="pnb:ShippingConditions"/>
						</KJWIND>
						<KJPACK>
							<xsl:value-of select="pnb:NumberOfCartons"/>
						</KJPACK>
						<KJPLAR>
							<xsl:value-of select="pnb:DeliveryType"/>
						</KJPLAR>
					</KJ>
					<LQ>
						<XXRCTY>
							<xsl:value-of select="'LQ'"/>
						</XXRCTY>
						<XXTRPA>
							<xsl:value-of select="$client"/>
						</XXTRPA>
						<XXDOTY>
							<xsl:value-of select="$documentType"/>
						</XXDOTY>
						<XXDONO>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</XXDONO>
						<LQDEPO>
							<xsl:value-of select="$depot"/>
						</LQDEPO>
						<LQCLIE>
							<xsl:value-of select="$client"/>
						</LQCLIE>
						<LQCORF>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</LQCORF>
						<LQLNNO>
							<xsl:value-of select="'10'"/>
						</LQLNNO>
						<LQHANL>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</LQHANL>
					</LQ>
					<LQ>
						<XXRCTY>
							<xsl:value-of select="'LQ'"/>
						</XXRCTY>
						<XXTRPA>
							<xsl:value-of select="$client"/>
						</XXTRPA>
						<XXDOTY>
							<xsl:value-of select="$documentType"/>
						</XXDOTY>
						<XXDONO>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</XXDONO>
						<LQDEPO>
							<xsl:value-of select="$depot"/>
						</LQDEPO>
						<LQCLIE>
							<xsl:value-of select="$client"/>
						</LQCLIE>
						<LQCORF>
							<xsl:value-of select="pnb:DeliveryNoteNbr"/>
						</LQCORF>
						<LQLNNO>
							<xsl:value-of select="'20'"/>
						</LQLNNO>
						<LQHANL>
							<xsl:value-of select="pnb:CustomField1"/>
						</LQHANL>
					</LQ>
					<xsl:for-each select="pnb:Address">
						<KK>
							<XXRCTY>
								<xsl:value-of select="'KK'"/>
							</XXRCTY>
							<XXTRPA>
								<xsl:value-of select="$client"/>
							</XXTRPA>
							<XXDOTY>
								<xsl:value-of select="$documentType"/>
							</XXDOTY>
							<XXDONO>
								<xsl:value-of select="../pnb:DeliveryNoteNbr"/>
							</XXDONO>
							<KKCLIE>
								<xsl:value-of select="$client"/>
							</KKCLIE>
							<KKCORF>
								<xsl:value-of select="../pnb:DeliveryNoteNbr"/>
							</KKCORF>
							<KKADTY>
								<xsl:value-of select="'2'"/>
							</KKADTY>
							<KKNAME>
								<xsl:value-of select="concat(pnb:FirstName , ' ' , pnb:LastName)"/>
							</KKNAME>
							<KKADD1>
								<xsl:choose>
									<xsl:when test="../pnb:SalesOrderType = 'ECO' and string-length(pnb:Address2) &gt; 0">
										<xsl:value-of select="pnb:Address2"/>
									</xsl:when>
									<xsl:when test="../pnb:SalesOrderType = 'ECO' and string-length(pnb:Address2) = 0">
										<xsl:value-of select="'adidas'"/>
									</xsl:when>
									<xsl:when test="not(../pnb:SalesOrderType = 'ECO')">
										<xsl:value-of select="pnb:City"/>
									</xsl:when>
								</xsl:choose>
							</KKADD1>
                                                        <KKADD2>
                                                                <xsl:choose>
                                                                        <xsl:when test="../pnb:SalesOrderType = 'ECO' ">
                                                                                <xsl:value-of select="pnb:Address1"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:value-of select="concat(pnb:Address1, ' ' , pnb:Address2)"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </KKADD2>
							<KKADD3>
								<xsl:value-of select="pnb:PhoneNo"/>
							</KKADD3>
							<KKADD4>
								<xsl:value-of select="pnb:City"/>
							</KKADD4>
							<KKPOST>
								<xsl:choose>
									<xsl:when test="../pnb:SalesOrderType = 'ECO' ">
										<xsl:value-of select="pnb:PostalCode"/>
									</xsl:when>
								</xsl:choose>
							</KKPOST>
							<KKCTRY>
								<xsl:value-of select="'CO'"/>
							</KKCTRY>
							<KKECLI>
								<xsl:value-of select="pnb:CustomerNo"/>
							</KKECLI>
							<KKVATN>
								<xsl:value-of select="pnb:State"/>
							</KKVATN>
							<KKEMAL>
								<xsl:value-of select="pnb:Email"/>
							</KKEMAL>
						</KK>
					</xsl:for-each>
					<xsl:for-each-group select="pnb:PickNoteDetails" group-ending-with="pnb:PickNoteDetails[(count(preceding::pnb:PickNoteDetails) + 1) mod $lineLimit = 0]">
						<G1>
							<KL>
								<XXRCTY>
									<xsl:value-of select="'KL'"/>
								</XXRCTY>
								<XXTRPA>
									<xsl:value-of select="$client"/>
								</XXTRPA>
								<XXDOTY>
									<xsl:value-of select="$documentType"/>
								</XXDOTY>
								<XXDONO>
									<xsl:value-of select="pnb:DeliveryNoteNbr"/>
								</XXDONO>
								<KLCLIE>
									<xsl:value-of select="$client"/>
								</KLCLIE>
								<KLCORF>
									<xsl:value-of select="pnb:DeliveryNoteNbr"/>
								</KLCORF>
								<KLLNNO>
									<xsl:value-of select="position()"/>
								</KLLNNO>
								<KLADTC>
									<xsl:value-of select="'DUMMY'"/>
								</KLADTC>
								<KLSSTS>
									<xsl:value-of select="'AGR'"/>
								</KLSSTS>
								<KLDES1>
									<xsl:value-of select="'DUMMY'"/>
								</KLDES1>
								<KLTEXT>
									<xsl:value-of select="'2'"/>
								</KLTEXT>
							</KL>
						</G1>
						<G1>
							<xsl:for-each select="current-group()">
								<KL>
									<XXRCTY>
										<xsl:value-of select="'KL'"/>
									</XXRCTY>
									<XXTRPA>
										<xsl:value-of select="$client"/>
									</XXTRPA>
									<XXDOTY>
										<xsl:value-of select="$documentType"/>
									</XXDOTY>
									<XXDONO>
										<xsl:value-of select="pnb:DeliveryNoteNbr"/>
									</XXDONO>
									<KLCLIE>
										<xsl:value-of select="$client"/>
									</KLCLIE>
									<KLCORF>
										<xsl:value-of select="pnb:DeliveryNoteNbr"/>
									</KLCORF>
									<KLLNNO>
										<xsl:value-of select="position()"/>
									</KLLNNO>
									<KLCOLN>
										<xsl:value-of select="pnb:DelScheduleLineNbr"/>
									</KLCOLN>
									<KLADTC>
										<xsl:value-of select="concat(pnb:ArticleNo,pnb:SizeIndex)"/>
									</KLADTC>
									<KLARR1>
										<xsl:value-of select="pnb:ArticleNo"/>
									</KLARR1>
									<KLSSTS>
										<xsl:choose>
											<xsl:when test="../pnb:VASRequired = 'Y'">
												<xsl:value-of select="'VAS'"/>
											</xsl:when>
											<xsl:when test="../pnb:VASRequired = 'N'">
												<xsl:call-template name="conv">
													<xsl:with-param name="TableNumber">2</xsl:with-param>
													<xsl:with-param name="Key" select="pnb:LocationCode"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</KLSSTS>
									<KLQUAN>
										<xsl:value-of select="pnb:DeliveryQuantity"/>
									</KLQUAN>
									<KLARR2>
										<xsl:value-of select="pnb:SizeDescription"/>
									</KLARR2>
									<KLARR3>
										<xsl:value-of select="pnb:SalesOrderNbr"/>
									</KLARR3>
									<!--<KLCONS>
										<xsl:value-of select="concat(DeliveryNoteNbr , '-' ,SalesOrderLineNbr)"/>
									</KLCONS>-->
									<KLLINE>
										<xsl:value-of select="position()"/>
									</KLLINE>
									<KLUNIT>
										<xsl:value-of select="concat(pnb:DeliveryLineNbr , '-' ,pnb:SalesOrderLineNbr)"/>
									</KLUNIT>
									<KLPKCL>
										<xsl:value-of select="'1'"/>
									</KLPKCL>
									<KLSUON>
										<xsl:value-of select="pnb:DeliveryLineNbr"/>
									</KLSUON>
									<KLSUOL>
										<xsl:value-of select="pnb:SalesOrderLineNbr"/>
									</KLSUOL>
								</KL>
							</xsl:for-each>
						</G1>
					</xsl:for-each-group>
				</xsl:for-each>
			</WHSORDER_0360>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="conv">
		<xsl:param name="TableNumber"/>
		<xsl:param name="Key"/>
		<xsl:variable name="URI" select="'../tabs/RadicoXDOTWO.xml'"/>
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

	<xsl:template match="PickNote">
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
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="..\xsd\WHSORDER_0360.xsd" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no">
			<SourceSchema srcSchemaPath="..\xsd\XDOTWO_001.xsd" srcSchemaRoot="" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/>
		</MapperInfo>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
