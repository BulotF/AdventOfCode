<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    
    <xsl:template match="/">
        <distances>
            <!-- Pour chaque planète, on compte son nombre d'ancêtres +1 ; on fait la somme pour l'ensemble des planètes -->
            <solution1>
                <xsl:value-of select="sum(//planet/count(ancestor-or-self::planet))"/>
            </solution1>
            <!-- On va de Santa au premier ancêtre commun en comptant Santa en trop et l'ancêtre en pas assez -->
            <!-- Puis de l'ancêtre commun à You -->
            <solution2>
                <xsl:value-of select="count(//planet[descendant::planet[@name='SAN'] and not(descendant::planet[@name='YOU'])]) 
                                    + count(//planet[descendant::planet[@name='YOU'] and not(descendant::planet[@name='SAN'])])"/>
            </solution2>
        </distances>
    </xsl:template>
    
</xsl:stylesheet>