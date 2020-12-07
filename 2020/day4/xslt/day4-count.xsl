<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    
    <xsl:template match="/">
        <Cards>
            <solution1>
                <xsl:value-of select="count(//Card[not(text()='absent')])"/>
            </solution1>
            <solution2>
                <xsl:value-of select="count(//Card[text()='to test'])"/>                
            </solution2>
        </Cards>
    </xsl:template>
    
</xsl:stylesheet>