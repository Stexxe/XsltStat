<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:variable name="var" select="test:func('val')"/>

        <xsl:value-of select="concat('DEBUG: ',test:con-cat('val', $var))"/>
        <xsl:value-of select="concat('DEBUG: ',test:con-cat('val', 123))"/>

        <xsl:message>
            <xsl:value-of select="test:text(Node)"/>
            {test:xslt3()}
        </xsl:message>

        <xsl:value-of select="concat(test:m1(), test:m2())"/>

        <xsl:value-of select="ex:complex(1, substring('some string', 1, 10), 'text')"/>

        <xsl:value-of select="xs:number('123')"/>

    </xsl:template>
</xsl:stylesheet>