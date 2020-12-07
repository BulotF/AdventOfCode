<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    
    <xsl:template match="/">
        <Cards>
            <xsl:apply-templates select="//Card"/>
        </Cards>
    </xsl:template>
    
    <xsl:template match="Card">
        <Card>
            <xsl:choose>
                <xsl:when test="not(pid and byr and iyr and ecl and eyr and hcl and hgt)">
                    <xsl:value-of select="'absent'"/>
                </xsl:when>
                <xsl:when test="not(matches(byr,'^[0-9]{4}$') and number(byr) &gt;= 1920 and number(byr) &lt;= 2002)">
                    <xsl:value-of select="concat('byr ',byr)"/>
                </xsl:when>
                <xsl:when test="not(matches(iyr,'^[0-9]{4}$') and number(iyr) &gt;= 2010 and number(iyr) &lt;= 2020)">
                    <xsl:value-of select="concat('iyr ',iyr)"/>
                </xsl:when>
                <xsl:when test="not(matches(eyr,'^[0-9]{4}$') and number(eyr) &gt;= 2020 and number(eyr) &lt;= 2030)">
                    <xsl:value-of select="concat('eyr ',eyr)"/>
                </xsl:when>
                <xsl:when test="not(matches(hgt,'^[0-9]+(in|cm)$'))">
                    <xsl:value-of select="concat('hgt ',hgt)"/>
                </xsl:when>
                <xsl:when test="ends-with(hgt,'cm') and not( number(substring-before(hgt,'cm')) &gt;= 150 and number(substring-before(hgt,'cm')) &lt;= 193)">
                    <xsl:value-of select="concat('hgt ',hgt)"/>
                </xsl:when>
                <xsl:when test="ends-with(hgt,'in') and not( number(substring-before(hgt,'in')) &gt;= 59 and number(substring-before(hgt,'in')) &lt;= 76)">
                    <xsl:value-of select="concat('hgt ',hgt)"/>
                </xsl:when>
                <xsl:when test="not(ecl = ('amb','blu','brn','gry','grn','hzl','oth'))">
                    <xsl:value-of select="concat('ecl ',ecl)"/>
                </xsl:when>
                <xsl:when test="not(matches(hcl,'^#[0-9a-f]{6}$'))">
                    <xsl:value-of select="concat('hcl ',hcl)"/>
                </xsl:when>
                <xsl:when test="not(matches(pid,'^[0-9]{9}$'))">
                    <xsl:value-of select="concat('pid ',pid)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'to test'"/>
                </xsl:otherwise>
            </xsl:choose>
        </Card>
    </xsl:template>
    
</xsl:stylesheet>