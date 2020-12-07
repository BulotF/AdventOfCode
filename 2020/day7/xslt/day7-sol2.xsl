<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    
    <xsl:template match="/">
        <Bags>
            <xsl:value-of select="sum(//Bag/@quantity)-1"/>
        </Bags>
    </xsl:template>
</xsl:stylesheet>