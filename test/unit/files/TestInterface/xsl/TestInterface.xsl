<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:variable name="var" select="test:func('val')"/>

        <xsl:value-of select="concat('DEBUG: ',test:con-cat('val', $var))"/>

        <xsl:call-template name="test">
            <xsl:with-param name="p1" select="123"/>
            <xsl:with-param name="p2">v2</xsl:with-param>
        </xsl:call-template>

    </xsl:template>
</xsl:stylesheet>