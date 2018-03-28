<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:call-template name="test">
            <xsl:with-param name="p1" select="123"/>
            <xsl:with-param name="p2">v2</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="test">
            <xsl:with-param name="p1" select="$var"/>
            <xsl:with-param name="p2">
                <xsl:value-of select="'123'"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>